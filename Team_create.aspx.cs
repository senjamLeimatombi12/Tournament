using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Runtime.CompilerServices;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Marathone
{
    
        public partial class Team_create : System.Web.UI.Page
        {
            string strcon = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

            protected void Page_Load(object sender, EventArgs e)
            {
                if (!IsPostBack)
                {
                    lblMessage.Text = "";
                }
            }

            // ----------------------------
            // FILTER MEMBERS BY AGE
            // ----------------------------
            protected void btnFilter_Click(object sender, EventArgs e)
            {
                int minAge, maxAge;

                if (int.TryParse(txtMinAge.Text, out minAge) && int.TryParse(txtMaxAge.Text, out maxAge))
                {
                    using (SqlConnection conn = new SqlConnection(strcon))
                    {
                        string query = @"
                        SELECT 
                            UserID AS ID, 
                            Name, 
                            DATEDIFF(YEAR, DOB, GETDATE()) AS Age, 
                            RFID
                        FROM Users
                        WHERE DATEDIFF(YEAR, DOB, GETDATE()) BETWEEN @MinAge AND @MaxAge";

                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@MinAge", minAge);
                            cmd.Parameters.AddWithValue("@MaxAge", maxAge);

                            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                            {
                                DataTable dt = new DataTable();
                                da.Fill(dt);

                                gvParticipants.DataSource = dt;
                                gvParticipants.DataBind();

                                if (dt.Rows.Count == 0)
                                {
                                    lblMessage.Text = "No participants found for this age range.";
                                    lblMessage.ForeColor = System.Drawing.Color.Red;
                                }
                                else
                                {
                                    lblMessage.Text = "";
                                }
                            }
                        }
                    }
                }
                else
                {
                    lblMessage.Text = "Please enter a valid age range.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                }
            }

            // ----------------------------
            // CREATE TEAM + INSERT MEMBERS
            // ----------------------------
            protected void btnCreateTeam_Click(object sender, EventArgs e)
            {
                string teamName = txtTeamName.Text.Trim();
                string date = txtDate.Text.Trim();

                if (string.IsNullOrEmpty(teamName))
                {
                    lblMessage.Text = "Please enter a team name.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                int teamId;

                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();

                    // CREATE TEAM (IF NOT EXISTS)
                    string insertTeamQuery = @"
                    IF NOT EXISTS (SELECT 1 FROM Teams WHERE TeamName = @TeamName)
                    INSERT INTO Teams(TeamName, CreatedDate)
                    VALUES (@TeamName, @Date);

                    SELECT TeamID FROM Teams WHERE TeamName = @TeamName;
                ";

                    using (SqlCommand cmd = new SqlCommand(insertTeamQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@TeamName", teamName);
                        cmd.Parameters.AddWithValue("@Date", date);

                        teamId = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    // ADD SELECTED MEMBERS
                    int count = 0;

                    foreach (GridViewRow row in gvParticipants.Rows)
                    {
                        CheckBox chk = (CheckBox)row.FindControl("chkSelect");

                        if (chk != null && chk.Checked)
                        {
                            int userId = Convert.ToInt32(gvParticipants.DataKeys[row.RowIndex].Value);
                            string name = row.Cells[2].Text;
                            int age = Convert.ToInt32(row.Cells[3].Text);
                            string rfid = row.Cells[4].Text;

                            string insertMemberQuery = @"
                            INSERT INTO TeamMembers(TeamID, UserID, Name, Age, RFID)
                            VALUES (@TeamID, @UserID, @Name, @Age, @RFID)";

                            using (SqlCommand cmd2 = new SqlCommand(insertMemberQuery, con))
                            {
                                cmd2.Parameters.AddWithValue("@TeamID", teamId);
                                cmd2.Parameters.AddWithValue("@UserID", userId);
                                cmd2.Parameters.AddWithValue("@Name", name);
                                cmd2.Parameters.AddWithValue("@Age", age);
                                cmd2.Parameters.AddWithValue("@RFID", rfid);
                                cmd2.ExecuteNonQuery();
                            }

                            count++;
                        }
                    }

                    lblMessage.Text = $"{count} members successfully added to team '{teamName}'.";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                }

                LoadTeamMembers(teamId);
            }

            // ----------------------------
            // LOAD MEMBERS FOR THIS TEAM
            // ----------------------------
            private void LoadTeamMembers(int teamId)
            {
                using (SqlConnection conn = new SqlConnection(strcon))
                {
                    string query = @"
                    SELECT 
                        MemberID,
                      Name,
                        Age,
                        RFID
                    FROM TeamMembers 
                    WHERE TeamID=@TeamID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@TeamID", teamId);

                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);

                            gvTeamMembers.DataKeyNames = new string[] { "MemberID" };
                            gvTeamMembers.DataSource = dt;
                            gvTeamMembers.DataBind();
                        }
                    }
                }
            }

            // ----------------------------
            // DELETE MEMBER FROM TEAM
            // ----------------------------
            protected void gvTeamMembers_RowCommand(object sender, GridViewCommandEventArgs e)
            {
                if (e.CommandName == "DeleteMember")
                {
                    int index = Convert.ToInt32(e.CommandArgument);
                    int memberId = Convert.ToInt32(gvTeamMembers.DataKeys[index].Value);

                    using (SqlConnection con = new SqlConnection(strcon))
                    {
                        con.Open();
                        string query = "DELETE FROM TeamMembers WHERE MemberID = @MemberID";

                        using (SqlCommand cmd = new SqlCommand(query, con))
                        {
                            cmd.Parameters.AddWithValue("@MemberID", memberId);
                            cmd.ExecuteNonQuery();
                        }
                    }

                    lblMessage.Text = "Member deleted successfully.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;

                    // reload team
                    string teamName = txtTeamName.Text.Trim();
                    int teamId = GetTeamID(teamName);
                    LoadTeamMembers(teamId);
                }
            }

            private int GetTeamID(string teamName)
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    string query = "SELECT TeamID FROM Teams WHERE TeamName=@Name";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Name", teamName);
                        con.Open();
                        object result = cmd.ExecuteScalar();
                        return result == null ? 0 : Convert.ToInt32(result);
                    }
                }
            }

        protected void btnCreateTeam1_Click(object sender, EventArgs e)
        {
            Response.Redirect("ViewAllTeam.aspx");
        }
    }
    }

