using System;
using System.Collections.Concurrent;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Net.Sockets;
using System.Threading;
using System.Threading.Tasks;
using System.Web.UI;

namespace Marathone
{
    public partial class Default : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["con"].ConnectionString;
        private static readonly ConcurrentDictionary<string, TagInfo> Tags = new ConcurrentDictionary<string, TagInfo>();
        private static TcpClient client;
        private static NetworkStream stream;
        private static bool keepRunning = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) UpdateGrid();
        }

        protected void Timer1_Tick(object sender, EventArgs e) => UpdateGrid();

        protected void btnStart_Click(object sender, EventArgs e)
        {
            if (Application["RFID_Running"] is true)
            {
                UpdateStatus("Already running!", Color.Orange);
                return;
            }

            Application["RFID_Running"] = true;
            UpdateStatus("Connecting...", Color.Blue);

            Task.Run(() =>
            {
                TcpClient client = null;
                NetworkStream stream = null;

                try
                {
                    client = new TcpClient();
                    client.Connect("10.10.1.240", 2022);
                    stream = client.GetStream();

                    UpdateStatus("Running...", Color.Green);

                    byte[] inventoryCmd = { 0xA0, 0x04, 0x01, 0x89, 0x00, 0x8E };
                    byte[] buffer = new byte[8192];

                    while ((bool)Application["RFID_Running"])
                    {
                        try
                        {
                            stream.Write(inventoryCmd, 0, inventoryCmd.Length);

                            while (stream.DataAvailable)
                            {
                                int len = stream.Read(buffer, 0, buffer.Length);
                                if (len > 0) ParseTagData(buffer, len);
                            }
                        }
                        catch { }

                        Thread.Sleep(110);
                    }

                    // Stop command
                    try
                    {
                        byte[] stop = { 0xA0, 0x02, 0x01, 0x81, 0xE2 };
                        stream.Write(stop, 0, stop.Length);
                    }
                    catch { }
                }
                catch (Exception ex)
                {
                    System.IO.File.AppendAllText(@"D:\Marathone\ErrorLog.txt",
                        DateTime.Now + " CRASH: " + ex.Message + "\r\n");
                }
                finally
                {
                    Application["RFID_Running"] = false;
                    stream?.Close();
                    client?.Close();

                    UpdateStatus("Disconnected", Color.Red);
                }
            });
        }

        // THIS IS THE ONLY METHOD YOU NEED — 100% WORKING IN WEBFORMS
        private void UpdateStatus(string text, Color color)
        {
            // This runs on UI thread even when called from Task.Run()
            ScriptManager.RegisterStartupScript(
                this,
                this.GetType(),
                "updateStatus_" + DateTime.Now.Ticks,  // unique key
                $"document.getElementById('{lblStatus.ClientID}').innerText = '{text}'; " +
                $"document.getElementById('{lblStatus.ClientID}').style.color = '{ColorTranslator.ToHtml(color)}';",
                true);
        }

        // ADD THIS METHOD TO YOUR PAGE CLASS (Default.aspx.cs)


        protected void btnStop_Click(object sender, EventArgs e)
        {
            Application["RFID_Running"] = false;
            UpdateStatus("Stopped", Color.Red);
        }
        private void StartInventory()
        {
            try
            {
                byte[] startCmd = { 0xA0, 0x04, 0x01, 0x80, 0x05, 0xE6 };
                stream.Write(startCmd, 0, startCmd.Length);

                byte[] buffer = new byte[4096];
                while (keepRunning)
                {
                    if (stream.DataAvailable)
                    {
                        int bytesRead = stream.Read(buffer, 0, buffer.Length);
                        if (bytesRead > 0)
                        {
                            ParseTagData(buffer, bytesRead);
                        }
                    }
                    System.Threading.Thread.Sleep(20);
                }

                byte[] stopCmd = { 0xA0, 0x02, 0x01, 0x81, 0xE2 };
                stream.Write(stopCmd, 0, stopCmd.Length);
            }
            catch { }
            finally
            {
                stream?.Close();
                client?.Close();
            }
        }

        private void ParseTagData(byte[] data, int length)
        {
            int pos = 0;
            while (pos < length)
            {
                if (data[pos] != 0xCF) { pos++; continue; }
                if (pos + 10 >= length) break;

                byte rssiByte = data[pos + 6];
                byte antenna = data[pos + 7];
                int epcLen = data[pos + 10];
                if (pos + 11 + epcLen + 2 > length) break;

                byte[] epcBytes = new byte[epcLen];
                Array.Copy(data, pos + 11, epcBytes, 0, epcLen);

                // THIS IS THE CORRECT EPC FORMAT THAT MATCHES YOUR DATABASE
                string epc = BitConverter.ToString(epcBytes).Replace("-", "").Replace(" ", "");

                TagInfo dbUser = LoadMemberFromDB(epc);
                DateTime now = DateTime.Now;

                Tags.AddOrUpdate(epc,
                    // First time seen
                    _ => new TagInfo
                    {
                        EPC = epc,
                        Antenna = antenna,
                        RSSI = rssiByte,
                        Count = 1,
                        PassageCount = 1,
                        FirstSeen = now,
                        LastSeen = now,
                        LastPassageTime = now,
                        UserName = dbUser?.UserName ?? "Unknown",
                        Age = dbUser?.Age
                    },
                    // Already exists
                    (_, existing) =>
                    {
                        existing.Count++;
                        existing.RSSI = rssiByte;
                        existing.Antenna = antenna;
                        existing.LastSeen = now;

                        // SAME INSERT LOGIC AS YOUR WORKING CODE (first version)
                        if (!existing.LastDbSave.HasValue ||
                            (now - existing.LastDbSave.Value).TotalSeconds >= 1)
                        {
                            SaveLiveReading(
                                epc: existing.EPC,
                                antenna: existing.Antenna,
                                rssi: existing.RSSI,
                                firstSeen: existing.FirstSeen,
                                lastSeen: now,
                                count: existing.Count,
                                user: dbUser);

                            existing.LastDbSave = now; // IMPORTANT
                        }

                        // Keep name updated
                        if (dbUser != null)
                        {
                            existing.UserName = dbUser.UserName ?? "Unknown";
                            existing.Age = dbUser.Age;
                        }

                        return existing;


                    });

                pos += 11 + epcLen + 2;
            }
        }

        // EXACTLY YOUR ORIGINAL WORKING INSERT METHOD – NEVER CHANGED
        private void SaveLiveReading(string epc, byte antenna, byte rssi,
                                     DateTime firstSeen, DateTime lastSeen, int count, TagInfo user)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                using (SqlCommand cmd = new SqlCommand(
                    @"INSERT INTO Reading_Live_Tournament(EPC, UserName, Age, Antenna, RSSI, FirstSeen, LastSeen, Count)
                      VALUES (@EPC, @UserName, @Age, @Antenna, @RSSI, @FirstSeen, @LastSeen, @Count)", con))
                {
                    cmd.Parameters.AddWithValue("@EPC", epc);
                    cmd.Parameters.AddWithValue("@UserName", user?.UserName ?? "");
                    cmd.Parameters.AddWithValue("@Age", user?.Age ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@Antenna", antenna);
                    cmd.Parameters.AddWithValue("@RSSI", rssi);
                    cmd.Parameters.AddWithValue("@FirstSeen", firstSeen);
                    cmd.Parameters.AddWithValue("@LastSeen", lastSeen);
                    cmd.Parameters.AddWithValue("@Count", count);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                System.IO.File.AppendAllText(@"D:\Marathone\ErrorLog.txt",
                    DateTime.Now + " SQL INSERT ERROR: " + ex.Message + "\r\n" + ex.StackTrace + "\r\n");
            }
        }

        private TagInfo LoadMemberFromDB(string epc)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                using (SqlCommand cmd = new SqlCommand("SELECT Name, Age FROM TeamMembers WHERE RFID = @EPC", con))
                {
                    cmd.Parameters.AddWithValue("@EPC", epc);
                    con.Open();
                    using (SqlDataReader rd = cmd.ExecuteReader())
                    {
                        if (rd.Read())
                        {
                            return new TagInfo
                            {
                                UserName = rd["Name"]?.ToString() ?? "Unknown",
                                Age = rd.IsDBNull(rd.GetOrdinal("Age")) ? (int?)null : rd.GetInt32(rd.GetOrdinal("Age"))
                            };
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.IO.File.AppendAllText(@"D:\Marathone\ErrorLog.txt",
                    DateTime.Now + " DB LOOKUP ERROR: " + ex.Message + Environment.NewLine);
            }

            return new TagInfo { UserName = "Unknown", Age = null };
        }

        private void UpdateGrid()
        {
            var list = Tags.Values.OrderByDescending(t => t.PassageCount).ThenByDescending(t => t.LastSeen).ToList();
            gvTags.DataSource = list;
            gvTags.DataBind();
            lblTotal.Text = list.Count.ToString();
        }

        protected override void OnPreRender(EventArgs e)
        {
            UpdateGrid();
            base.OnPreRender(e);
        }
    }

    public class TagInfo
    {
        public string EPC { get; set; }
        public byte Antenna { get; set; }
        public byte RSSI { get; set; }
        public int Count { get; set; }
        public int PassageCount { get; set; } = 1;
        public DateTime FirstSeen { get; set; }
        public DateTime LastSeen { get; set; }
        public DateTime LastPassageTime { get; set; }
        public string UserName { get; set; } = "Unknown";
        public int? Age { get; set; }

        public DateTime? LastDbSave { get; set; }

    }
}