using BCrypt.Net; // Add BCrypt.Net via NuGet: Install-Package BCrypt.Net-Next
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Net.NetworkInformation;
using System.Web.Helpers;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Marathone
{
    public partial class Tornament_Registration_Form : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Optional: Set default agreement date to today
                txtAgreementDate.Text = DateTime.Today.ToString("yyyy-MM-dd");
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            lblStatus.Visible = false;

            if (!Page.IsValid)
                return;

            try
            {
                if (!ValidateServerSide())
                    return;

                // Required file
                if (!FileUploadIDCard.HasFile)
                {
                    ShowError("Please upload ID Card document.");
                    return;
                }

                string idFilePath = SaveFile(FileUploadIDCard, "IDCards");
                string medicalFilePath = FileUploadMedical.HasFile
                    ? SaveFile(FileUploadMedical, "MedicalDocs")
                    : null;

                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();

                    string query = @"
                    INSERT INTO Users
                    (
                        Name, Username, Email, Phone, PasswordHash,
                        Nationality, Gender, Height, Qualification,
                        GovtIDType, GovtIDNumber, IDCardFile, PassportNumber,
                        Signature, AgreementDate,
                        HasChronicIllness, ChronicIllnessDetails,
                        HasAllergies, AllergyDetails, MedicalDocument,
                        PhysicianName, PhysicianPhone,
                        InsuranceCompany, InsuranceGroup,
                        GuardianName, GuardianRelationship, GuardianEmail, GuardianPhone,
                        AddressLine, City, State, Country, Pincode
                    )
                    VALUES
                    (
                        @Name, @Username, @Email, @Phone, @PasswordHash,
                        @Nationality, @Gender, @Height, @Qualification,
                        @GovtIDType, @GovtIDNumber, @IDCardFile, @PassportNumber,
                        @Signature, @AgreementDate,
                        @HasChronic, @ChronicDetails,
                        @HasAllergy, @AllergyDetails, @MedicalDocument,
                        @PhysicianName, @PhysicianPhone,
                        @InsuranceCompany, @InsuranceGroup,
                        @GuardianName, @GuardianRelation, @GuardianEmail, @GuardianPhone,
                        @AddressLine, @City, @State, @Country, @Pincode

                    ); ";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        string fullName = txtFirstName.Text.Trim() + " " + txtLastName.Text.Trim();
                        string hashedPassword = BCrypt.Net.BCrypt.HashPassword(txtPassword.Text);

                        cmd.Parameters.AddWithValue("@Name", fullName);
                        cmd.Parameters.AddWithValue("@Username", txtEmail.Text.Trim());
                        cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                        cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
                        cmd.Parameters.AddWithValue("@PasswordHash", hashedPassword);

                        cmd.Parameters.AddWithValue("@Nationality", "Indian");
                        cmd.Parameters.AddWithValue("@Gender", ddlGender.SelectedValue);
                        cmd.Parameters.AddWithValue("@Height", decimal.Parse(txtHeight.Text.Trim()));
                        cmd.Parameters.AddWithValue("@Qualification", txtQualification.Text.Trim());

                        cmd.Parameters.AddWithValue("@GovtIDType", ddlIDType.SelectedValue);
                        cmd.Parameters.AddWithValue("@GovtIDNumber", Guid.NewGuid().ToString());
                        cmd.Parameters.AddWithValue("@IDCardFile", idFilePath);
                        cmd.Parameters.AddWithValue("@PassportNumber", DBNull.Value);

                        cmd.Parameters.AddWithValue("@Signature", txtSignature.Text.Trim());
                        cmd.Parameters.AddWithValue("@AgreementDate", DateTime.Parse(txtAgreementDate.Text));

                        bool hasChronic = !string.IsNullOrWhiteSpace(txtChronic.Text);
                        bool hasAllergy = !string.IsNullOrWhiteSpace(txtAllergies.Text);

                        cmd.Parameters.AddWithValue("@HasChronic", hasChronic);
                        cmd.Parameters.AddWithValue("@ChronicDetails",
                            hasChronic ? txtChronic.Text.Trim() : (object)DBNull.Value);

                        cmd.Parameters.AddWithValue("@HasAllergy", hasAllergy);
                        cmd.Parameters.AddWithValue("@AllergyDetails",
                            hasAllergy ? txtAllergies.Text.Trim() : (object)DBNull.Value);

                        cmd.Parameters.AddWithValue("@MedicalDocument",
                            (object)medicalFilePath ?? DBNull.Value);

                        cmd.Parameters.AddWithValue("@PhysicianName",
                            txtPhysicianName.Text.Trim());
                        cmd.Parameters.AddWithValue("@PhysicianPhone", txtPhysicianPhone.Text.Trim());

                        cmd.Parameters.AddWithValue("@InsuranceCompany", txtInsuranceCompany.Text.Trim());
                        
                        cmd.Parameters.AddWithValue("@InsuranceGroup", txtGroupNumber.Text.Trim());

                        cmd.Parameters.AddWithValue("@GuardianName", txtGuardianName.Text.Trim());
                        cmd.Parameters.AddWithValue("@GuardianRelation", txtGuardianRelation.Text.Trim());
                        cmd.Parameters.AddWithValue("@GuardianEmail", txtGuardianEmail.Text.Trim());
                        cmd.Parameters.AddWithValue("@GuardianPhone", txtGuardianPhone.Text.Trim());

                        string fullAddress = (txtAddress1.Text + " " + txtAddress2.Text).Trim();
                        cmd.Parameters.AddWithValue("@AddressLine", fullAddress);
                        cmd.Parameters.AddWithValue("@City", txtCity.Text.Trim());
                        cmd.Parameters.AddWithValue("@State", txtState.Text.Trim());
                        cmd.Parameters.AddWithValue("@Country", "India");
                        cmd.Parameters.AddWithValue("@Pincode", txtPostal.Text.Trim());

                        cmd.ExecuteNonQuery();
                    }
                }

                ClientScript.RegisterStartupScript(this.GetType(), "success",
                    "alert('Registration Successful!'); window.location='ApplicationDetailReview.aspx';", true);
            }
            catch (Exception ex)
            {
                ShowError("Error: " + ex.Message);
            }
        }

        // Server-side validation method
        private bool ValidateServerSide()
        {
            // Check agreements
            if (!chkAgree1.Checked || !chkAgree2.Checked || !chkAgree3.Checked)
            {
                ShowError("You must agree to all terms and conditions.");
                return false;
            }

            // Phone number exactly 10 digits
            if (!System.Text.RegularExpressions.Regex.IsMatch(txtPhone.Text.Trim(), @"^\d{10}$"))
            {
                ShowError("Athlete phone must be exactly 10 digits.");
                return false;
            }

            if (!System.Text.RegularExpressions.Regex.IsMatch(txtGuardianPhone.Text.Trim(), @"^\d{10}$"))
            {
                ShowError("Guardian phone must be exactly 10 digits.");
                return false;
            }

            // Postal code 6 digits
            if (!System.Text.RegularExpressions.Regex.IsMatch(txtPostal.Text.Trim(), @"^\d{6}$"))
            {
                ShowError("Postal code must be exactly 6 digits.");
                return false;
            }

            return true;
        }

        // Email uniqueness validator (called from ASPX CustomValidator)
        protected void cvEmailUnique_ServerValidate(object source, ServerValidateEventArgs args)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();
                    string query = "SELECT COUNT(*) FROM Users WHERE Email = @Email";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                        int count = (int)cmd.ExecuteScalar();
                        args.IsValid = (count == 0);
                    }
                }
            }
            catch
            {
                args.IsValid = false;
            }
        }

        // Helper: Show error message
        private void ShowError(string message)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "error",
                $"alert('Validation Error: {message.Replace("'", "\\'")}');", true);
        }

        protected void cvAgreements_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = chkAgree1.Checked && chkAgree2.Checked && chkAgree3.Checked;
        }

        // File save helper
        private string SaveFile(System.Web.UI.WebControls.FileUpload fileUpload, string folderName)
        {
            if (fileUpload.HasFile)
            {
                string folderPath = Server.MapPath($"~/Uploads/{folderName}/");
                if (!Directory.Exists(folderPath))
                    Directory.CreateDirectory(folderPath);

                string fileName = Guid.NewGuid().ToString() + Path.GetExtension(fileUpload.FileName);
                string fullPath = Path.Combine(folderPath, fileName);
                fileUpload.SaveAs(fullPath);
                return $"~/Uploads/{folderName}/{fileName}";
            }
            return null;
        }
    }
}