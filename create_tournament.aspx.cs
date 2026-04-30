using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Marathone
{
    public partial class create_tournament : Page
    {
        string conStr = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTournaments();
            }
        }

        private void LoadTournaments()
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    "SELECT * FROM Tournaments ORDER BY CreatedDate DESC", con);

                DataTable dt = new DataTable();
                da.Fill(dt);

                gvTournaments.DataSource = dt;
                gvTournaments.DataBind();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtTournamentName.Text) ||
                string.IsNullOrWhiteSpace(txtVenue.Text) ||
                string.IsNullOrWhiteSpace(txtTournamentDate.Text) ||
                string.IsNullOrWhiteSpace(txtDistance.Text))
            {
                lblMessage.Text = "Please fill all required fields.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            int minAge = string.IsNullOrEmpty(txtMinAge.Text) ? 0 : Convert.ToInt32(txtMinAge.Text);
            int maxAge = string.IsNullOrEmpty(txtMaxAge.Text) ? 0 : Convert.ToInt32(txtMaxAge.Text);

            if (minAge > 0 && maxAge > 0 && minAge > maxAge)
            {
                lblMessage.Text = "Min Age cannot be greater than Max Age.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            using (SqlConnection con = new SqlConnection(conStr))
            {
                SqlCommand cmd;

                if (!string.IsNullOrEmpty(hfTournamentID.Value))
                {
                    cmd = new SqlCommand(@"
                        UPDATE Tournaments SET
                            TournamentName=@TournamentName,
                            Venue=@Venue,
                            TournamentDate=@TournamentDate,
                            MinAge=@MinAge,
                            MaxAge=@MaxAge,
                            DistanceMeters=@DistanceMeters,
                            Status=@Status
                        WHERE TournamentID=@TournamentID", con);

                    cmd.Parameters.AddWithValue("@TournamentID", hfTournamentID.Value);
                }
                else
                {
                    cmd = new SqlCommand(@"
                        INSERT INTO Tournaments
                        (TournamentName, Venue, TournamentDate, MinAge, MaxAge, DistanceMeters, Status)
                        VALUES
                        (@TournamentName, @Venue, @TournamentDate, @MinAge, @MaxAge, @DistanceMeters, @Status)", con);
                }

                cmd.Parameters.AddWithValue("@TournamentName", txtTournamentName.Text.Trim());
                cmd.Parameters.AddWithValue("@Venue", txtVenue.Text.Trim());
                cmd.Parameters.AddWithValue("@TournamentDate", Convert.ToDateTime(txtTournamentDate.Text));
                cmd.Parameters.AddWithValue("@MinAge", minAge == 0 ? (object)DBNull.Value : minAge);
                cmd.Parameters.AddWithValue("@MaxAge", maxAge == 0 ? (object)DBNull.Value : maxAge);
                cmd.Parameters.AddWithValue("@DistanceMeters", Convert.ToInt32(txtDistance.Text));
                cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            lblMessage.Text = "Tournament saved successfully!";
            lblMessage.ForeColor = System.Drawing.Color.Green;

            ClearForm();
            LoadTournaments();
        }

        protected void gvTournaments_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditTournament")
            {
                int id = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection con = new SqlConnection(conStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "SELECT * FROM Tournaments WHERE TournamentID=@ID", con);
                    cmd.Parameters.AddWithValue("@ID", id);

                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        hfTournamentID.Value = dr["TournamentID"].ToString();
                        txtTournamentName.Text = dr["TournamentName"].ToString();
                        txtVenue.Text = dr["Venue"].ToString();
                        txtTournamentDate.Text = Convert.ToDateTime(dr["TournamentDate"]).ToString("yyyy-MM-dd");
                        txtMinAge.Text = dr["MinAge"] == DBNull.Value ? "" : dr["MinAge"].ToString();
                        txtMaxAge.Text = dr["MaxAge"] == DBNull.Value ? "" : dr["MaxAge"].ToString();
                        txtDistance.Text = dr["DistanceMeters"].ToString();
                        ddlStatus.SelectedValue = dr["Status"].ToString();

                        btnSave.Text = "Update Tournament";
                    }
                }
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            hfTournamentID.Value = "";
            txtTournamentName.Text = "";
            txtVenue.Text = "";
            txtTournamentDate.Text = "";
            txtMinAge.Text = "";
            txtMaxAge.Text = "";
            txtDistance.Text = "";
            ddlStatus.SelectedIndex = 0;

            btnSave.Text = "Create Tournament";
        }
    }
}
