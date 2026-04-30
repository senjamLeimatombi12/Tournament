using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.DynamicData;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Marathone
{
    public partial class view_all_tournaments : System.Web.UI.Page
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString);

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTournaments();
            }
        }

        private void LoadTournaments()
        {
            try
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT TournamentID, TournamentName, Venue, TournamentDate FROM Tournaments ORDER BY TournamentID DESC ", con);


                    DataTable dt = new DataTable();
                da.Fill(dt);

                gvTournaments.DataSource = dt;
                gvTournaments.DataBind();

                    
            }
            catch(Exception ex)
            {
                Response.Write("<script>alert('Error loading tournaments:" + ex.Message + "');</script>");

            }
        }

        protected void gvTournaments_PageIndexChanging(object sender, System.Web.UI.WebControls.GridViewPageEventArgs e)
        {
            gvTournaments.PageIndex = e.NewPageIndex;
            LoadTournaments();
        }

        protected void gvTournaments_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            int tournamentId = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "ViewTournament")
            {
                LoadTournamentDetails(tournamentId);
            }
            else if (e.CommandName == "DeleteTournament")
            {
                DeleteTournament(tournamentId);
                LoadTournaments();
            }
        }

       
            
    
        private void LoadTournamentDetails(int tournamentId)
        {
            try
            {
                SqlDataAdapter da = new SqlDataAdapter(@"SELECT
                                                    TT.TournamentID,
                                                    T.TeamID,
                                                    T.TeamName
                                                    FROM TournamentTeams TT
                                                    JOIN Teams T ON TT.TeamID=T.TeamID
                                                    WHERE TT.TournamentID=@TournamentID
                                                    ORDER BY T.TeamName",con);

                da.SelectCommand.Parameters.AddWithValue("@TournamentID", tournamentId);

                DataTable dt = new DataTable();
                da.Fill(dt);

                gvTournamentDetails.DataSource = dt;
                gvTournamentDetails.DataBind();            
            
            }
            catch(Exception ex)
            {
                Response.Write("<script>alert('Error loading details: " + ex.Message + "');</script>");
            }

        }

        private void DeleteTournament(int tournamentId)
        {
            try
            {
                SqlCommand cmd = new SqlCommand(
                    "DELETE FROM Tournaments WHERE TournamentID=@TournamentID", con);
                cmd.Parameters.AddWithValue("@TournamentID", tournamentId);
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();

                Response.Write("<script>alert('Tournament deleted successfully');</script>");

            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error deleting:" + ex.Message + "');</script>");

            }


        }

        protected void gvTournamentDetails_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if(e.CommandName=="ViewMembers")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = gvTournamentDetails.Rows[rowIndex];

                int teamId = Convert.ToInt32(gvTournamentDetails.DataKeys[rowIndex].Value);
                LoadMembers(teamId);
            }
        }

        private void LoadMembers(int teamId)
        {
            try
            {
                string query = "SELECT MemberID, Name, Age, RFID FROM TeamMembers WHERE TeamID = @TeamID";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@TeamID", teamId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvMembers.DataSource = dt;
                gvMembers.DataBind();

                
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error loading team members: " + ex.Message + "');</script>");
            }
        }
        private void LoadAllMembers(int tournamentId)
        {
            try
            {
                string query = @"
            SELECT M.MemberID, M.Name, M.Age, M.RFID, T.TeamName
            FROM TeamMembers M
            INNER JOIN Teams T ON M.TeamID = T.TeamID
            INNER JOIN TournamentTeams TT ON T.TeamID = TT.TeamID
            WHERE TT.TournamentID = @TournamentID
            ORDER BY M.MemberID ASC"; 

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@TournamentID", tournamentId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvMembers.DataSource = dt;
                gvMembers.DataBind();

                lblTotalMembers.Text = "Total Members: " + dt.Rows.Count;
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error loading members: " + ex.Message + "');</script>");
            }
        }

        protected void btnViewAllMembers_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int tournamentId = Convert.ToInt32(btn.CommandArgument);
            LoadAllMembers(tournamentId);
        }

        protected void gvTournaments_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Optional: highlight selected row or do something
            // For example, you can just keep it empty if you only need the selected row later
        }


    }


}