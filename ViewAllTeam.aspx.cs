using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using System.Linq;
using System.Web;
using System.Web.UI;


namespace Marathone
{
    public partial class ViewAllTeam : System.Web.UI.Page
    {
        string conStr = ConfigurationManager.ConnectionStrings["con"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                LoadTeams();
            }
        }

        private void LoadTeams()
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {

                string query = "SELECT TeamID, TeamName, CreatedDate FROM Teams";

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvTeams.DataSource = dt;
                gvTeams.DataBind();

            }
        }

        protected void gvTeams_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if(e.CommandName=="ViewMembers")
            {
                int teamId = Convert.ToInt32(e.CommandArgument);
                LoadMembers(teamId);
            }

            if(e.CommandName=="DeleteTeam")
            {
                int teamId = Convert.ToInt32(e.CommandArgument);
                DeleteTeam(teamId);
                LoadTeams();
                gvMembers.DataSource = null;
                gvMembers.DataBind();
            }
        }

        private void DeleteTeam(int teamId)
        {
            using(SqlConnection con = new SqlConnection(conStr))
            {
                string query = "DELETE FROM Teams WHERE TeamID=@TeamID";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@TeamID", teamId);

                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

       private void LoadMembers(int teamId)
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                string query = "SELECT MemberID,name, Age, RFID FROM TeamMembers WHERE TeamID=@TeamID";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@TeamID", teamId);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvMembers.DataSource = dt;
                gvMembers.DataBind();
            
            
            
            }
        }

    }
}