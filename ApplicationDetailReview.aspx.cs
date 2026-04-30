using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;

namespace Marathone
{
    public partial class ApplicationDetailReview : System.Web.UI.Page
    {
        private readonly string strcon =
            ConfigurationManager.ConnectionStrings["con"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadLatestApplication();
            }
        }

        private void LoadLatestApplication()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();

                    string query = @"
                    SELECT TOP 1
                        UserID, Name, Username, Email, Phone,

                        Nationality, Gender, Height, Qualification,

                        GovtIDType, GovtIDNumber, IDCardFile, PassportNumber,

                        Signature, AgreementDate,

                        HasChronicIllness, ChronicIllnessDetails,
                        HasAllergies, AllergyDetails, MedicalDocument,

                        PhysicianName, PhysicianPhone,

                        InsuranceCompany, InsurancePolicy, InsuranceGroup,

                        GuardianName, GuardianRelationship, GuardianEmail, GuardianPhone,

                        AddressLine, City, State, Country, Pincode,

                        CreatedDate
                    FROM Users
                    ORDER BY CreatedDate DESC
                    ";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            pnlDetails.Controls.Add(
                                new LiteralControl("<p class='text-danger'>No application found.</p>")
                            );
                            return;
                        }

                        ViewState["UserID"] = reader["UserID"];

                        StringBuilder sb = new StringBuilder();

                        // ================= PERSONAL INFORMATION =================
                        sb.Append("<div class='topic-box'>");
                        sb.Append("<div class='topic-title'>Personal Information</div>");

                        AddRow(sb, "Name", reader["Name"], "Gender", Safe(reader, "Gender"));
                        AddRow(sb, "Email", reader["Email"], "Phone", reader["Phone"]);
                        AddRow(sb, "Nationality", Safe(reader, "Nationality"), "Qualification", Safe(reader, "Qualification"));
                        AddRow(sb, "Height", Safe(reader, "Height"), "", "");

                        sb.Append("</div>");

                        // ================= ADDRESS =================
                        sb.Append("<div class='topic-box'>");
                        sb.Append("<div class='topic-title'>Address</div>");

                        string address =
                            $"{Safe(reader, "AddressLine")}, {Safe(reader, "City")}, " +
                            $"{Safe(reader, "State")}, {Safe(reader, "Country")} - {Safe(reader, "Pincode")}";

                        sb.Append("<div class='detail-row full-row'>");
                        sb.Append("<div class='detail-item'><label>Full Address</label><div>" + address + "</div></div>");
                        sb.Append("</div>");

                        sb.Append("</div>");

                        // ================= EMERGENCY CONTACT =================
                        sb.Append("<div class='topic-box'>");
                        sb.Append("<div class='topic-title'>Emergency Contact</div>");

                        AddRow(sb, "Name", Safe(reader, "GuardianName"),
                                     "Relationship", Safe(reader, "GuardianRelationship"));
                        AddRow(sb, "Email", Safe(reader, "GuardianEmail"),
                                     "Phone", Safe(reader, "GuardianPhone"));

                        sb.Append("</div>");

                        // ================= HEALTH INFORMATION =================
                        sb.Append("<div class='topic-box'>");
                        sb.Append("<div class='topic-title'>Health Information</div>");

                        AddRow(sb,
                            "Chronic Illness", BoolYesNo(reader, "HasChronicIllness"),
                            "Allergies", BoolYesNo(reader, "HasAllergies"));

                        AddRow(sb,
                            "Illness Details", Safe(reader, "ChronicIllnessDetails"),
                            "Allergy Details", Safe(reader, "AllergyDetails"));

                        if (reader["MedicalDocument"] != DBNull.Value)
                        {
                            sb.Append("<div class='detail-row full-row'>");
                            sb.Append("<div class='detail-item'><label>Medical Report</label>");
                            sb.Append("<div><a target='_blank' href='" +
                                      reader["MedicalDocument"].ToString().Replace("~", "") +
                                      "'>View Document</a></div></div>");
                            sb.Append("</div>");
                        }

                        sb.Append("</div>");

                        // ================= Physician & Insurance =================
                        sb.Append("<div class='topic-box'>");
                        sb.Append("<div class='topic-title'>Physician & Insurance</div>");

                        AddRow(sb, "Physician Name", Safe(reader, "PhysicianName"),
                                     "Physician Phone", Safe(reader, "PhysicianPhone"));

                        AddRow(sb, "Insurance Company", Safe(reader, "InsuranceCompany"),
                                     "Policy Number", Safe(reader, "InsurancePolicy"));

                        AddRow(sb, "Insurance Group", Safe(reader, "InsuranceGroup"), "", "");

                        sb.Append("</div>");


                        // ================= IDENTIFICATION =================
                        sb.Append("<div class='topic-box'>");
                        sb.Append("<div class='topic-title'>Identification</div>");

                        AddRow(sb, "ID Type", Safe(reader, "GovtIDType"),
                                     "ID Number", Safe(reader, "GovtIDNumber"));

                        if (reader["IDCardFile"] != DBNull.Value)
                        {
                            sb.Append("<div class='detail-row full-row'>");
                            sb.Append("<div class='detail-item'><label>ID Card</label>");
                            sb.Append("<div><a target='_blank' href='" +
                                      reader["IDCardFile"].ToString().Replace("~", "") +
                                      "'>View Document</a></div></div>");
                            sb.Append("</div>");
                        }

                        sb.Append("</div>");


                        // ================= AGREEMENT =================
                        sb.Append("<div class='topic-box'>");
                        sb.Append("<div class='topic-title'>Agreement</div>");

                        AddRow(sb, "Signature", Safe(reader, "Signature"),
                                     "Agreement Date", Safe(reader, "AgreementDate"));

                        sb.Append("</div>");

                        pnlDetails.Controls.Add(new LiteralControl(sb.ToString()));
                    }
                }
            }
            catch (Exception ex)
            {
                pnlDetails.Controls.Add(
                    new LiteralControl("<p class='text-danger'>Error: " + ex.Message + "</p>")
                );
            }
        }

        // ================= HELPERS =================

        private string Safe(SqlDataReader reader, string column)
        {
            return reader[column] == DBNull.Value ? "" : reader[column].ToString();
        }

        private string BoolYesNo(SqlDataReader reader, string column)
        {
            if (reader[column] == DBNull.Value) return "No";
            return Convert.ToBoolean(reader[column]) ? "Yes" : "No";
        }

        private void AddRow(StringBuilder sb, string label1, object value1, string label2, object value2)
        {
            sb.Append("<div class='detail-row'>");

            sb.Append("<div class='detail-item'><label>" + label1 + "</label><div>" + value1 + "</div></div>");

            if (!string.IsNullOrEmpty(label2))
                sb.Append("<div class='detail-item'><label>" + label2 + "</label><div>" + value2 + "</div></div>");

            sb.Append("</div>");
        }

        // ================= BUTTON EVENTS =================

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Tornament_Registration_Form.aspx");
        }

        protected void btnFinalSubmit_Click(object sender, EventArgs e)
        {
            if (ViewState["UserID"] == null) return;

            int userId = Convert.ToInt32(ViewState["UserID"]);

            ClientScript.RegisterStartupScript(
                this.GetType(),
                "ok",
                "alert('Application submitted successfully'); window.location='Login.aspx';",
                true
            );
        }
    }
}
