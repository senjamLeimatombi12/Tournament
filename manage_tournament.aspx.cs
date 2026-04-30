using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Marathone
{
    public partial class manage_tournament : System.Web.UI.Page
    {
        string conStr = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTournaments();
                LoadUsersGrid();
            }
        }

        // ================= LOAD TOURNAMENTS =================
        private void LoadTournaments()
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    "SELECT TournamentID, TournamentName, TournamentDate, Status FROM Tournaments ORDER BY TournamentDate DESC", con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvTournaments.DataSource = dt;
                gvTournaments.DataBind();
            }
        }

        // ================= LOAD USERS GRID =================
        private void LoadUsersGrid()
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    "SELECT UserID, Name, Email FROM Users ORDER BY Name", con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvUsers.DataSource = dt;
                gvUsers.DataBind();
            }
        }

        // ================= LOAD MEMBERS =================
        private void LoadMembers(int tournamentId)
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT 
                tm.TournamentMemberID,
                tm.UserID,
                t.TournamentName,
                tm.MemberName,
                tm.EPC
            FROM TournamentMembers tm
            INNER JOIN Tournaments t
                ON tm.TournamentID = t.TournamentID
            WHERE tm.TournamentID = @ID
            ORDER BY tm.MemberName", con);

                cmd.Parameters.AddWithValue("@ID", tournamentId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvMembers.DataSource = dt;
                gvMembers.DataBind();
            }
        }




        // ================= TOURNAMENT COMMANDS =================
        protected void gvTournaments_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int tournamentId = Convert.ToInt32(e.CommandArgument);

            hfTournamentID.Value = tournamentId.ToString();

            if (e.CommandName == "ViewMembers")
            {
                LoadMembers(tournamentId);
                pnlUsers.Visible = false;
            }
            else if (e.CommandName == "AddMembers")
            {
                LoadAvailableUsers(tournamentId);
                pnlUsers.Visible = true;    // popup opens
            }
            else if (e.CommandName == "DeleteTournament")
            {
                using (SqlConnection con = new SqlConnection(conStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "DELETE FROM Tournaments WHERE TournamentID=@ID", con);
                    cmd.Parameters.AddWithValue("@ID", tournamentId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                lblMsg.Text = "Tournament deleted successfully.";
                lblMsg.ForeColor = System.Drawing.Color.Green;

                LoadTournaments();
                gvMembers.DataSource = null;
                gvMembers.DataBind();
                pnlUsers.Visible = false;
            }
        }




   

        protected void btnAddSelected_Click(object sender, EventArgs e)
        {
            int tournamentId;

            if (!int.TryParse(hfTournamentID.Value, out tournamentId))
            {
                lblMsg.Text = "Please select a tournament first.";
                return;
            }

            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();

                foreach (GridViewRow row in gvUsers.Rows)
                {
                    CheckBox chk = row.FindControl("chkUser") as CheckBox;

                    if (chk != null && chk.Checked)
                    {
                        int userId = Convert.ToInt32(
                            gvUsers.DataKeys[row.RowIndex].Value);

                        SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO TournamentMembers (TournamentID, UserID, MemberName)
                    SELECT @TID, UserID, Name
                    FROM Users
                    WHERE UserID = @UID", con);

                        cmd.Parameters.AddWithValue("@TID", tournamentId);
                        cmd.Parameters.AddWithValue("@UID", userId);

                        cmd.ExecuteNonQuery();
                    }
                }
            }

            // Refresh member list
            LoadMembers(tournamentId);

            // Hide popup grid
            pnlUsers.Visible = false;

            lblMsg.Text = "Selected members added successfully.";
            lblMsg.ForeColor = System.Drawing.Color.Green;
        }

        // ================= ADD SELECTED MEMBERS =================
        protected void btnAddSelectedMembers_Click(object sender, EventArgs e)
        {
            lblMsg.Text = "";
            lblMsg.ForeColor = System.Drawing.Color.Black;

            int tournamentId;
            if (!int.TryParse(hfTournamentID.Value, out tournamentId) || tournamentId <= 0)
            {
                lblMsg.Text = "Please select a tournament first.";
                return;
            }

            int addedCount = 0;

            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();
                foreach (GridViewRow row in gvUsers.Rows)
                {
                    CheckBox chk = row.FindControl("chkSelectUser") as CheckBox;
                    if (chk != null && chk.Checked)
                    {
                        int userId = Convert.ToInt32(gvUsers.DataKeys[row.RowIndex].Value);

                        // Prevent duplicates
                        SqlCommand checkCmd = new SqlCommand(
                            "SELECT COUNT(*) FROM TournamentMembers WHERE TournamentID = @TID AND UserID = @UID", con);
                        checkCmd.Parameters.AddWithValue("@TID", tournamentId);
                        checkCmd.Parameters.AddWithValue("@UID", userId);

                        int exists = (int)checkCmd.ExecuteScalar();
                        if (exists == 0)
                        {
                            SqlCommand insertCmd = new SqlCommand(@"
                                INSERT INTO TournamentMembers (TournamentID, UserID, MemberName, EPC)
                                SELECT @TID, UserID, Name, NULL FROM Users WHERE UserID = @UID", con);

                            insertCmd.Parameters.AddWithValue("@TID", tournamentId);
                            insertCmd.Parameters.AddWithValue("@UID", userId);

                            addedCount += insertCmd.ExecuteNonQuery();
                        }
                    }
                }
            }

            lblMsg.Text = $"{addedCount} member(s) added successfully.";
            lblMsg.ForeColor = System.Drawing.Color.Green;

            LoadMembers(tournamentId);
        }

        

        protected void btnShowUsers_Click(object sender, EventArgs e)
        {
            int tournamentId;
            if (!int.TryParse(hfTournamentID.Value, out tournamentId))
            {
                lblMsg.Text = "Please select a tournament first.";
                return;
            }

            LoadAvailableUsers(tournamentId);

            pnlUsers.Visible = true;   // 🔥 popup appears
        }

        void LoadAvailableUsers(int tournamentId)
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT U.UserID, U.Name, U.Email
            FROM Users U
            WHERE NOT EXISTS (
                SELECT 1 FROM TournamentMembers TM
                WHERE TM.UserID = U.UserID
                  AND TM.TournamentID = @TID
            )
            ORDER BY U.Name", con);

                cmd.Parameters.AddWithValue("@TID", tournamentId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvUsers.DataSource = dt;
                gvUsers.DataBind();
            }
        }

        // ================= REMOVE MEMBER =================
        protected void gvMembers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "RemoveMember")
            {
                int memberId;
                if (!int.TryParse(e.CommandArgument.ToString(), out memberId)) return;

                using (SqlConnection con = new SqlConnection(conStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "DELETE FROM TournamentMembers WHERE TournamentMemberID = @ID", con);
                    cmd.Parameters.AddWithValue("@ID", memberId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                int tournamentId;
                if (int.TryParse(hfTournamentID.Value, out tournamentId))
                    LoadMembers(tournamentId);
            }
        }
    }
}
