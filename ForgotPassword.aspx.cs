using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Net;
using System.Text;
using Newtonsoft.Json;

namespace Marathone
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        // Database connection string
        string strcon = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

        // ===================== OTP GENERATOR =====================
        private string GenerateOTP()
        {
            Random rnd = new Random();
            return rnd.Next(100000, 999999).ToString(); // 6-digit OTP
        }

        // ===================== SEND OTP =====================
        protected void btnSendOTP_Click(object sender, EventArgs e)
        {
            string phone = txtMobile.Text.Trim();
            string role = rbAdmin.Checked ? "Admin" : "User";
            string tableName = role == "Admin" ? "Admins" : "Users";

            // 1️⃣ Validate phone
            if (phone.Length != 10)
            {
                Alert("Enter a valid 10-digit phone number");
                return;
            }

            // 2️⃣ Check if phone exists
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                string query = $"SELECT COUNT(*) FROM {tableName} WHERE Phone=@Phone AND IsActive=1";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Phone", phone);

                int count = Convert.ToInt32(cmd.ExecuteScalar());
                if (count == 0)
                {
                    Alert("Phone number not found");
                    return;
                }
            }

            // 3️⃣ Generate OTP
            string otp = GenerateOTP();

            // 4️⃣ Store OTP in Session (with expiry)
            Session["OTP"] = otp;
            Session["OTP_PHONE"] = phone;
            Session["OTP_ROLE"] = role;
            Session["OTP_EXPIRY"] = DateTime.Now.AddMinutes(5);

            // 5️⃣ Send SMS
           
            string message = $"Please enter the OTP code {otp} in the appropriate field to confirm your mobile number. CubeTen Technologies";


            if (SendSMS(phone, message))
            {
                pnlReset.Visible = true;
                Alert("OTP sent successfully");
            }
            else
            {
                Alert("Failed to send OTP. Try again.");
            }
        }

        // ===================== RESET PASSWORD =====================
        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            // 1️⃣ Validate OTP existence
            if (Session["OTP"] == null)
            {
                Alert("OTP expired. Please resend.");
                return;
            }

            // 2️⃣ Check OTP expiry
            DateTime expiry = (DateTime)Session["OTP_EXPIRY"];
            if (DateTime.Now > expiry)
            {
                Session.Clear();
                Alert("OTP expired. Please resend.");
                return;
            }

            // 3️⃣ Verify OTP
            if (txtOTP.Text.Trim() != Session["OTP"].ToString())
            {
                Alert("Invalid OTP");
                return;
            }

            // 4️⃣ Hash new password
            string newPassword = txtNewPassword.Text.Trim();
            if (newPassword.Length < 8)
            {
                Alert("Password must be at least 8 characters");
                return;
            }

            string passwordHash = BCrypt.Net.BCrypt.HashPassword(newPassword);

            string role = Session["OTP_ROLE"].ToString();
            string tableName = role == "Admin" ? "Admins" : "Users";
            string phone = Session["OTP_PHONE"].ToString();

            // 5️⃣ Update password
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                string query = $"UPDATE {tableName} SET PasswordHash=@Pwd WHERE Phone=@Phone";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Pwd", passwordHash);
                cmd.Parameters.AddWithValue("@Phone", phone);
                cmd.ExecuteNonQuery();
            }

            // 6️⃣ Clear session
            Session.Clear();

            AlertRedirect("Password reset successful. Please login.", "Login.aspx");
        }

        // ===================== BULK SMS API =====================
        public bool SendSMS(string phone, string message)
        {
            try
            {
                model_messge sms = new model_messge
                {
                    api_id = "APIloyC1FWX144247",
                    api_password = "$2y$10$GoRrH6w8/pguSNckk7UXuOiH52U4Bi8biy90vKzm2pJ5JW0IOPyoS",
                    sms_type = "Transactional",
                    sms_encoding = "1",
                    sender = "DEMOSM",
                    number = "91" + phone,
                    message = message,
                    template_id = "185606"
                };

                string json = JsonConvert.SerializeObject(sms);
                byte[] data = Encoding.UTF8.GetBytes(json);

                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(
                    "https://bulksmsplans.com/api/send_sms");

                request.Method = "POST";
                request.ContentType = "application/json";
                request.ContentLength = data.Length;

                using (Stream stream = request.GetRequestStream())
                {
                    stream.Write(data, 0, data.Length);
                }

                using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
                using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                {
                    string result = reader.ReadToEnd().ToLower();
                    return result.Contains("success");
                }
            }
            catch
            {
                return false;
            }
        }

        // ===================== HELPER METHODS =====================
        private void Alert(string message)
        {
            ClientScript.RegisterStartupScript(this.GetType(),
                "alert", $"alert('{message}');", true);
        }

        private void AlertRedirect(string message, string url)
        {
            ClientScript.RegisterStartupScript(this.GetType(),
                "alert", $"alert('{message}'); window.location='{url}';", true);
        }
    }
}

















































