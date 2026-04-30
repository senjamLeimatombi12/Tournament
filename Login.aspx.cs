using System;
using System.Configuration;
using System.Data.SqlClient;

        
namespace Marathone
    {
        public partial class Login : System.Web.UI.Page
        {
            // Connection string from Web.config
            string strcon = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

            protected void btnLogin_Click(object sender, EventArgs e)
            {
                string email = txtEmail.Text.Trim();
                string password = txtPassword.Text.Trim();

                // Determine login type based on radio button
                string loginType = rbAdmin.Checked ? "Admin" : "User";

                // Map table and ID column based on login type
                string tableName = loginType == "Admin" ? "Admins" : "Users";
                string idColumn = loginType == "Admin" ? "AdminID" : "UserID";

                try
                {
                    using (SqlConnection con = new SqlConnection(strcon))
                    {
                        con.Open();

                        // Query to check email and active status
                        string query = $@"
                        SELECT {idColumn}, PasswordHash 
                        FROM {tableName} 
                        WHERE Email = @Email AND IsActive = 1";

                        using (SqlCommand cmd = new SqlCommand(query, con))
                        {
                            cmd.Parameters.AddWithValue("@Email", email);

                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    string storedHash = reader["PasswordHash"].ToString();

                                    // Verify password with BCrypt
                                    if (BCrypt.Net.BCrypt.Verify(password, storedHash))
                                    {
                                        int userId = Convert.ToInt32(reader[idColumn]);

                                        // Set session
                                        Session["UserID"] = userId;
                                        Session["Email"] = email;
                                        Session["Role"] = loginType;

                                        // Redirect based on role
                                        if (loginType == "Admin")
                                            Response.Redirect("~/Admin.aspx");
                                        else
                                            Response.Redirect("~/Profile.aspx");

                                        Context.ApplicationInstance.CompleteRequest();
                                    }
                                    else
                                    {
                                        ShowError();
                                    }
                                }
                                else
                                {
                                    ShowError();
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    // Show generic error
                    Response.Write("<script>alert('An error occurred. Please try again.');</script>");
                }
            }

            // Display invalid login alert
            private void ShowError()
            {
                Response.Write("<script>alert('Invalid email, password, or account inactive.');</script>");
            }
        }
    

}
    

  