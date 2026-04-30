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
    public partial class Tournament_Live_Page : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                LoadTournaments();
            }
        }


        private void LoadTournaments()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = "SELECT TournamentsID, TournamentName FROM Tournaments ORDER BY CreatedDate DESC";
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlTournaments.DataSource = dt;
                ddlTournaments.DataValueField = "TournamentID";
                ddlTournaments.DataBind();
                ddlTournaments.Items.Insert(0, new ListItem("--Select Tournament--", ""));

            }
        }

        protected void ddlTournaments_SelectedIndexChanged(object sender, EventArgs e)
        {

            if (!string.IsNullOrEmpty(ddlTournaments.SelectedValue))
            {
                LoadLeaderboard();
            }
        }

        private void LoadLeaderboard()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = @"
                SELECT
                fr.Rank,
                u.Name,
                DATEDIFF(YEAR, u.DOB<, GETDATE()) AS Age,
                u.Team,
                fr.StartTime,
                fr.FinishTime,
                RIGHT(')' + CAST(fr.TotalTimeSeconds/3600 AS VARCHER),2) + ':
                RIGHT('0' + CAST((fr.TotalTimeSeconds%3600)/60 AS VARCHER),2) + ':' +
                RIGHT('0' + CAST(fr.TotalTimeSeconds%60 AS VARCHER), 2 ) AS TotalTime,
                CASE
                     WHEN fr.FinishTime IS NULL THEN
                CASE WHEN fr.StartTime IS NULL THEN 'Not Started' ELSE 'Running' END
                ELSE 'Finished'
                END AS Status
                FROM FinalResults fr
                INNER JOIN Users u ON fr.UserID = u.UserID
                WHERE fr.TournamentID=@TournamentID
                ORDER BY fr.Rank ASC";

                SqlCommand cmd = new SqlCommand(query, con);
                {
                    cmd.Parameters.AddWithValue("@TournamentID", ddlTournaments.SelectedValue);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvLeaderboard.DataSource = dt;
                    gvLeaderboard.DataBind();
                    UpdateSummary(dt);

                }
            }


        }

        private void UpdateSummary(DataTable dt)
        {
            int total = dt.Rows.Count;
            int finished = dt.Select("Status = 'Finished'").Length;
            int started = dt.Select("Status='Running' OR Status ='Finished'").Length;
            int ongoing = total - finished;

            lblTotalAthletes.Text = total.ToString();
            lblFinished.Text = finished.ToString();
            lblStarted.Text = started.ToString();
            lblOngoing.Text = ongoing.ToString();



        }

        protected void gvLeaderboard_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                int rank = Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Rank"));
                if (rank == 1) e.Row.CssClass = "gold";
                else if (rank == 2) e.Row.CssClass = "silver";
                else if (rank == 3) e.Row.CssClass = "bronze";
            }
        }

        protected void Timer1_Tick(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(ddlTournaments.SelectedValue))
            {
                LoadLeaderboard();
            }
        }
    }
}












































               