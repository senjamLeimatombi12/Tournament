using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Marathone
{
    public partial class RFID_TAG_Assign : System.Web.UI.Page
    {
        string conStr = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

        int TournamentID = 1; // SET CURRENT TOURNAMENT ID

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadMembers();
        }

        void LoadMembers()
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();

                SqlDataAdapter da1 = new SqlDataAdapter(
                    "SELECT * FROM TournamentMembers WHERE TournamentID=@tid AND EPC IS NOT NULL", con);
                da1.SelectCommand.Parameters.AddWithValue("@tid", TournamentID);
                DataTable dt1 = new DataTable();
                da1.Fill(dt1);
                gvWithRFID.DataSource = dt1;
                gvWithRFID.DataBind();

                SqlDataAdapter da2 = new SqlDataAdapter(
                    "SELECT * FROM TournamentMembers WHERE TournamentID=@tid AND EPC IS NULL", con);
                da2.SelectCommand.Parameters.AddWithValue("@tid", TournamentID);
                DataTable dt2 = new DataTable();
                da2.Fill(dt2);
                gvWithoutRFID.DataSource = dt2;
                gvWithoutRFID.DataBind();
            }
        }

        protected void gv_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int memberId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "SaveRFID")
            {
                GridViewRow row = ((Button)e.CommandSource).NamingContainer as GridViewRow;
                TextBox txt = row.FindControl("txtRFID") as TextBox;

                if (txt == null || txt.Text.Trim() == "") return;

                using (SqlConnection con = new SqlConnection(conStr))
                {
                    con.Open();

                    SqlCommand check = new SqlCommand(
                        "SELECT COUNT(*) FROM TournamentMembers WHERE TournamentID=@tid AND EPC=@epc", con);
                    check.Parameters.AddWithValue("@tid", TournamentID);
                    check.Parameters.AddWithValue("@epc", txt.Text.Trim());

                    if ((int)check.ExecuteScalar() > 0)
                    {
                        lblMsg.Text = "RFID already exists";
                        return;
                    }

                    SqlCommand cmd = new SqlCommand(
                        "UPDATE TournamentMembers SET EPC=@epc WHERE TournamentMemberID=@id", con);
                    cmd.Parameters.AddWithValue("@epc", txt.Text.Trim());
                    cmd.Parameters.AddWithValue("@id", memberId);
                    cmd.ExecuteNonQuery();
                }
            }

            if (e.CommandName == "DeleteRFID")
            {
                using (SqlConnection con = new SqlConnection(conStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "UPDATE TournamentMembers SET EPC=NULL WHERE TournamentMemberID=@id", con);
                    cmd.Parameters.AddWithValue("@id", memberId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            LoadMembers();
        }

        protected void gvWithRFID_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvWithRFID.EditIndex = e.NewEditIndex;
            LoadMembers();
        }

        protected void gvWithRFID_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvWithRFID.EditIndex = -1;
            LoadMembers();
        }

        protected void gvWithRFID_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int memberId = Convert.ToInt32(gvWithRFID.DataKeys[e.RowIndex]["TournamentMemberID"]);
            int tournamentId = Convert.ToInt32(gvWithRFID.DataKeys[e.RowIndex]["TournamentID"]);

            TextBox txt = gvWithRFID.Rows[e.RowIndex].FindControl("txtEditRFID") as TextBox;
            if (txt == null || txt.Text.Trim() == "") return;

            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();

                SqlCommand check = new SqlCommand(
                    @"SELECT COUNT(*) FROM TournamentMembers 
                      WHERE TournamentID=@tid AND EPC=@epc AND TournamentMemberID<>@id", con);
                check.Parameters.AddWithValue("@tid", tournamentId);
                check.Parameters.AddWithValue("@epc", txt.Text.Trim());
                check.Parameters.AddWithValue("@id", memberId);

                if ((int)check.ExecuteScalar() > 0)
                {
                    lblMsg.Text = "RFID already exists";
                    return;
                }

                SqlCommand cmd = new SqlCommand(
                    "UPDATE TournamentMembers SET EPC=@epc WHERE TournamentMemberID=@id", con);
                cmd.Parameters.AddWithValue("@epc", txt.Text.Trim());
                cmd.Parameters.AddWithValue("@id", memberId);
                cmd.ExecuteNonQuery();
            }

            gvWithRFID.EditIndex = -1;
            LoadMembers();
        }
    }
}
