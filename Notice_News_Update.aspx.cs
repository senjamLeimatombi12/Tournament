using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Marathone
{

    public partial class Notice_News_Update : System.Web.UI.Page
    {
        string conStr = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

       
        protected void btnSave_Click(object sender, EventArgs e)
        {
                try
                {
                    using (SqlConnection con = new SqlConnection(conStr))
                    {
                        string query = @"
                        INSERT INTO TournamentNotices (Title, Description, CreatedDate)
                        VALUES (@Title, @Description, GETDATE())";

                        using (SqlCommand cmd = new SqlCommand(query, con))
                        {
                            cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                            cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());

                            con.Open();
                            cmd.ExecuteNonQuery();

                            lblMessage.Text = "✅ Notice published successfully!";
                            lblMessage.CssClass = "success";

                            txtTitle.Text = "";
                            txtDescription.Text = "";
                        }
                    }
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "❌ Error: " + ex.Message;
                    lblMessage.CssClass = "error";
                }
            
        }
    }
}