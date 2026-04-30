using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace Marathone
{
    public partial class User_Registration : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            if (checkMemberExists())
            {
                Response.Write("<script>alert('Username already exists. Try a different one.');</script>");
            }
            else
            {
                signUpNewMember();
            }
        }

        // ✅ Check if username already exists
        bool checkMemberExists()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();
                    string query = "SELECT COUNT(*) FROM Users WHERE Username = @Username";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@Username", TextBox9.Text.Trim());

                    int count = Convert.ToInt32(cmd.ExecuteScalar());
                    return count > 0;
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message.Replace("'", "") + "');</script>");
                return false;
            }
        }

        // ✅ Register new member
        void signUpNewMember()
        {
            try
            {
                // 🔒 Validate password strength
                if (!IsStrongPassword(TextBox10.Text.Trim()))
                {
                    Response.Write("<script>alert('Password must contain at least 8 characters, including uppercase, lowercase, number, and special character.');</script>");
                    return;
                }

                // ✅ Convert and validate date
                DateTime dob;
                if (!DateTime.TryParse(TextBox3.Text.Trim(), out dob))
                {
                    Response.Write("<script>alert('Invalid Date of Birth');</script>");
                    return;
                }

                string hashedPassword = HashPassword(TextBox10.Text.Trim());
                string nationality = ddlNationality.SelectedValue;
                string idType = ddlGovtIDType.SelectedValue;
                string idNumber = txtGovtID.Text.Trim();

                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();

                    string query = @"
                        INSERT INTO Users
                        (Name, Username, DOB, Phone, Email, State, Country, Pincode, Address, PasswordHash,
                         GovtIDType, GovtIDNumber, PassportNumber, Nationality, Today_Date)
                        VALUES
                        (@Name, @Username, @dob, @Phone, @Email, @State, @Country, @Pincode, @Address, @Password,
                         @GovtIDType, @GovtIDNumber, @PassportNumber, @Nationality, GETDATE())";

                    SqlCommand cmd = new SqlCommand(query, con);

                    cmd.Parameters.AddWithValue("@Name", TextBox1.Text.Trim());
                    cmd.Parameters.AddWithValue("@Username", TextBox9.Text.Trim());
                    cmd.Parameters.AddWithValue("@dob", dob);
                    cmd.Parameters.AddWithValue("@Phone", TextBox2.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", TextBox4.Text.Trim());
                    cmd.Parameters.AddWithValue("@State", TextBox5.Text.Trim());
                    cmd.Parameters.AddWithValue("@Country", TextBox6.Text.Trim());
                    cmd.Parameters.AddWithValue("@Pincode", TextBox7.Text.Trim());
                    cmd.Parameters.AddWithValue("@Address", TextBox8.Text.Trim());
                    cmd.Parameters.AddWithValue("@Password", hashedPassword);
                    cmd.Parameters.AddWithValue("@GovtIDType", idType);
                    cmd.Parameters.AddWithValue("@Nationality", nationality);
                    cmd.Parameters.AddWithValue("@GovtIDNumber", nationality == "Indian" ? (object)idNumber : DBNull.Value);
                    cmd.Parameters.AddWithValue("@PassportNumber", nationality != "Indian" ? (object)idNumber : DBNull.Value);

                    cmd.ExecuteNonQuery();
                    Response.Write("<script>alert('Sign Up Successful! Please log in.'); window.location='Login.aspx';</script>");

                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Database Error: " + ex.Message.Replace("'", "") + "');</script>");
            }
        }

        // ✅ Password hashing (SHA256)
        string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder builder = new StringBuilder();
                foreach (byte b in bytes)
                {
                    builder.Append(b.ToString("x2"));
                }
                return builder.ToString();
            }
        }

        // ✅ Password strength validator
        bool IsStrongPassword(string password)
        {
            if (password.Length < 8) return false;
            bool hasUpper = false, hasLower = false, hasDigit = false, hasSpecial = false;

            foreach (char c in password)
            {
                if (char.IsUpper(c)) hasUpper = true;
                else if (char.IsLower(c)) hasLower = true;
                else if (char.IsDigit(c)) hasDigit = true;
                else hasSpecial = true;
            }

            return hasUpper && hasLower && hasDigit && hasSpecial;
        }
    }
}
