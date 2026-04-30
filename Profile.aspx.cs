using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;

namespace Marathone
{
    public partial class Profile : System.Web.UI.Page
    {
        string conStr = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
                LoadProfile();
        }

        void LoadProfile()
        {
            int userID = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection con = new SqlConnection(conStr))
            {
                string query = @"
                    SELECT Name, Email, Phone, DOB, AddressLine, City, State, Country, Pincode,
                           Nationality, GuardianName, GuardianRelationship, GuardianPhone, GuardianEmail,
                           ProfilePhoto, IDCardFile
                    FROM Users WHERE UserID = @UserID";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserID", userID);
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    txtName.Text = dr["Name"].ToString();
                    txtEmail.Text = dr["Email"].ToString();
                    txtPhone.Text = dr["Phone"].ToString();

                    if (dr["DOB"] != DBNull.Value)
                        txtDOB.Text = Convert.ToDateTime(dr["DOB"]).ToString("yyyy-MM-dd");

                    txtAddress.Text = dr["AddressLine"].ToString();
                    txtCity.Text = dr["City"].ToString();
                    txtState.Text = dr["State"].ToString();
                    txtCountry.Text = dr["Country"].ToString();
                    txtPincode.Text = dr["Pincode"].ToString();
                    txtNationality.Text = dr["Nationality"].ToString();
                    txtGuardianName.Text = dr["GuardianName"].ToString();
                    txtGuardianRelationship.Text = dr["GuardianRelationship"].ToString();
                    txtGuardianPhone.Text = dr["GuardianPhone"].ToString();
                    txtGuardianEmail.Text = dr["GuardianEmail"].ToString();

                    // Profile Photo
                    string photo = dr["ProfilePhoto"] as string;
                    if (!string.IsNullOrWhiteSpace(photo))
                    {
                        imgProfile.ImageUrl = ResolveUrl(photo) + "?v=" + DateTime.Now.Ticks;
                    }
                    else
                    {
                        imgProfile.ImageUrl = ResolveUrl("~/imgs/profile.jpg");
                    }

                    // ID Card
                    if (dr["IDCardFile"] != DBNull.Value && !string.IsNullOrWhiteSpace(dr["IDCardFile"].ToString()))
                    {
                        imgIDCard.ImageUrl = ResolveUrl(dr["IDCardFile"].ToString());
                        imgIDCard.Visible = true;
                        lblNoIDCard.Visible = false;
                    }
                    else
                    {
                        imgIDCard.Visible = false;
                        lblNoIDCard.Visible = true;
                    }
                }
                dr.Close();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            int userID = Convert.ToInt32(Session["UserID"]);
            string profilePhotoPath = "";
            string idCardPath = "";

            // Profile Photo Upload
            if (FileUpload1.HasFile)
            {
                string folder = Server.MapPath("~/Uploads/ProfilePhotos/");
                if (!Directory.Exists(folder))
                    Directory.CreateDirectory(folder);

                string fileName = "P_" + userID + Path.GetExtension(FileUpload1.FileName);
                profilePhotoPath = "~/Uploads/ProfilePhotos/" + fileName;
                FileUpload1.SaveAs(Path.Combine(folder, fileName));
            }

            // ID Card Upload
            if (FileUploadIDCard.HasFile)
            {
                string folder = Server.MapPath("~/Uploads/IDCards/");
                if (!Directory.Exists(folder))
                    Directory.CreateDirectory(folder);

                string fileName = "ID_" + userID + Path.GetExtension(FileUploadIDCard.FileName);
                idCardPath = "~/Uploads/IDCards/" + fileName;
                FileUploadIDCard.SaveAs(Path.Combine(folder, fileName));
            }

            // Update Database
            using (SqlConnection con = new SqlConnection(conStr))
            {
                string query = @"
                    UPDATE Users SET
                        Name = @Name,
                        Email = @Email,
                        Phone = @Phone,
                        DOB = @DOB,
                        AddressLine = @Address,
                        City = @City,
                        State = @State,
                        Country = @Country,
                        Pincode = @Pincode,
                        Nationality = @Nationality,
                        GuardianName = @GuardianName,
                        GuardianRelationship = @GuardianRelationship,
                        GuardianPhone = @GuardianPhone,
                        GuardianEmail = @GuardianEmail,
                        ProfilePhoto = CASE WHEN @ProfilePhoto = '' THEN ProfilePhoto ELSE @ProfilePhoto END,
                        IDCardFile = CASE WHEN @IDCard = '' THEN IDCardFile ELSE @IDCard END
                    WHERE UserID = @UserID";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
                cmd.Parameters.AddWithValue("@DOB", string.IsNullOrEmpty(txtDOB.Text) ? (object)DBNull.Value : txtDOB.Text);
                cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());
                cmd.Parameters.AddWithValue("@City", txtCity.Text.Trim());
                cmd.Parameters.AddWithValue("@State", txtState.Text.Trim());
                cmd.Parameters.AddWithValue("@Country", txtCountry.Text.Trim());
                cmd.Parameters.AddWithValue("@Pincode", txtPincode.Text.Trim());
                cmd.Parameters.AddWithValue("@Nationality", txtNationality.Text.Trim());
                cmd.Parameters.AddWithValue("@GuardianName", txtGuardianName.Text.Trim());
                cmd.Parameters.AddWithValue("@GuardianRelationship", txtGuardianRelationship.Text.Trim());
                cmd.Parameters.AddWithValue("@GuardianPhone", txtGuardianPhone.Text.Trim());
                cmd.Parameters.AddWithValue("@GuardianEmail", txtGuardianEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@ProfilePhoto", profilePhotoPath);
                cmd.Parameters.AddWithValue("@IDCard", idCardPath);
                cmd.Parameters.AddWithValue("@UserID", userID);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            // Reload to show changes
            LoadProfile();
        }
    }
}