using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace Marathone
{
    public partial class UserInfo : System.Web.UI.Page
    {
        string conStr = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userid"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadProfile();
            }
        }

        private void LoadProfile()
        {
            int userID = Convert.ToInt32(Session["userid"]);

            using (SqlConnection con = new SqlConnection(conStr))
            {
                string query = @"
                    SELECT Name, Email, Phone, DOB, AddressLine, City, State, Country, Pincode,
                           Nationality, GuardianName, GuardianRelationship, GuardianPhone, GuardianEmail,
                           ProfilePhoto, IDCardFile
                    FROM Users 
                    WHERE UserID = @UserID";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserID", userID);
                con.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        string name = dr["Name"].ToString();

                        // Large centered profile name and picture
                        litName.Text = name;

                        // About section - all read-only Literals
                        litName2.Text = name;
                        litEmail.Text = dr["Email"].ToString();
                        litPhone.Text = dr["Phone"].ToString();

                        if (dr["DOB"] != DBNull.Value)
                        {
                            litDOB.Text = Convert.ToDateTime(dr["DOB"]).ToString("dd MMM yyyy");
                        }
                        else
                        {
                            litDOB.Text = "";
                        }

                        litAddress.Text = dr["AddressLine"].ToString();
                        litCity.Text = dr["City"].ToString();
                        litState.Text = dr["State"].ToString();
                        litCountry.Text = dr["Country"].ToString();
                        litPincode.Text = dr["Pincode"].ToString();
                        litNationality.Text = dr["Nationality"].ToString();
                        litGuardianName.Text = dr["GuardianName"].ToString();
                        litGuardianRelationship.Text = dr["GuardianRelationship"].ToString();
                        litGuardianPhone.Text = dr["GuardianPhone"].ToString();
                        litGuardianEmail.Text = dr["GuardianEmail"].ToString();

                        // Large Profile Photo (centered at top)
                        string photo = dr["ProfilePhoto"] as string;
                        if (!string.IsNullOrWhiteSpace(photo))
                        {
                            imgProfile.ImageUrl = ResolveUrl(photo) + "?v=" + DateTime.Now.Ticks;
                        }
                        else
                        {
                            imgProfile.ImageUrl = ResolveUrl("~/Assets/noimage.png");
                        }

                        // ID Card Display
                        string idCardFile = dr["IDCardFile"] as string;
                        if (!string.IsNullOrWhiteSpace(idCardFile))
                        {
                            imgIDCard.ImageUrl = ResolveUrl(idCardFile);
                            imgIDCard.Visible = true;
                            lblNoIDCard.Visible = false;
                        }
                        else
                        {
                            imgIDCard.Visible = false;
                            lblNoIDCard.Visible = true;
                            lblNoIDCard.Text = "No ID Card Uploaded";
                        }
                    }
                }
            }
        }
    }
}