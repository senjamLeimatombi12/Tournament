using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Marathone
{
    public partial class homepage : System.Web.UI.Page
    {
 
            private readonly string conStr = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Master != null)
            {
                var side = Master.FindControl("sidebar");
                if (side != null)
                {
                    side.Visible = false;
                }
            }

            if (!IsPostBack)
            {
                LoadNotices();
            }
        }



        private void LoadNotices()
            {
                try
                {
                    using (SqlConnection con = new SqlConnection(conStr))
                    {
                        string query = @"SELECT TOP 1 Title, Description, CreatedDate 
                                     FROM TournamentNotices 
                                     ORDER BY CreatedDate DESC";

                        SqlDataAdapter da = new SqlDataAdapter(query, con);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        rptNotices.DataSource = dt;
                        rptNotices.DataBind();
                    }
                }
                catch (Exception ex)
                {
                    Response.Write("<b>Error:</b> " + ex.Message);
                }
            }
        }
    }
