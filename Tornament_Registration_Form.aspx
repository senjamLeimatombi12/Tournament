<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Tornament_Registration_Form.aspx.cs" Inherits="Marathone.Tornament_Registration_Form" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<style>
    body, html, form {
        background-color: #f5f7fa !important;
        font-family: 'Segoe UI', Arial, sans-serif;
        margin: 0;
        padding: 0;
    }

    .container-box {
        background: white;
        padding: 60px 40px;
        border-radius: 20px;
        box-shadow: 0 20px 60px rgba(0,0,0,0.12);
        margin: 60px auto;
        max-width: 1000px;
        border-top: 6px solid #77C7F3;
    }

    .logo-header {
        text-align: center;
        margin-bottom: 40px;
    }

    .logo-header img {
        width: 140px;
        height: 140px;
        object-fit: cover;
        border-radius: 50%;
        border: 6px solid #fff;
        box-shadow: 0 12px 35px rgba(119,199,243,0.3);
        margin-bottom: 20px;
    }

    h3 {
        font-family: 'Segoe UI', 'Times New Roman', serif;
        font-size: 2rem;
        color: #1c252e;
        font-weight: 700;
        margin: 0;
        letter-spacing: 0.8px;
        text-shadow: 0 4px 12px rgba(119, 199, 243, 0.12);
    }

    h5 {
        color: #1c252e;
        font-weight: 600;
        font-size: 1.3rem;
        margin-top: 40px;
        margin-bottom: 20px;
        padding-bottom: 8px;
        border-bottom: 2px solid #77C7F3;
    }

    label {
        font-weight: 500;
        color: #34495e;
        margin: 8px 0 4px;
        font-size: 0.95rem;
    }

    .form-control, .form-select {
        padding: 10px 16px;
        height: 44px;
        border: 1px solid #ddd;
        border-radius: 10px;
        font-size: 15px;
        width: 100%;
        transition: all 0.3s;
        box-sizing: border-box;
    }

    textarea.form-control {
        min-height: 80px;
        height: auto;
    }

    .form-control:focus, .form-select:focus {
        border-color: #77C7F3;
        box-shadow: 0 0 0 4px rgba(119,199,243,0.25);
        outline: none;
    }

    .btn-professional {
        background-color: #77C7F3;
        color: #fff;
        font-size: 17px;
        font-weight: 600;
        padding: 15px 50px;
        border: none;
        border-radius: 14px;
        box-shadow: 0 8px 25px rgba(119,199,243,0.4);
        transition: all 0.3s ease;
        cursor: pointer;
    }

    .btn-professional:hover {
        background-color: #5ab5e8;
        box-shadow: 0 15px 40px rgba(119,199,243,0.6);
        transform: translateY(-3px);
    }

    .required { color: #e74c3c; font-weight: bold; }

    .error-msg {
        color: #e74c3c;
        font-size: 0.875em;
        margin-top: 5px;
        display:block;
    }

    hr {
        border-color: #eef2f6;
        margin: 30px 0;
    }

    .row {
        display: flex;
        flex-wrap: wrap;
        gap: 15px;
    }

    .row > div {
        flex: 1 1 45%;
    }

    /* Checkbox fixes */
    .form-check-input {
        width: 1em !important;
        height: 1em !important;
        border: 1px solid #adb5bd !important;
        background-color: #fff !important;
        border-radius: 0.25em;
        box-shadow: none !important;
        accent-color: #777 !important;
    }

    .form-check-input:focus {
        box-shadow: none !important;
    }

    .form-check-input:checked {
        background-color: #77C7F3 !important;
        border-color: #77C7F3 !important;
    }

    /* Responsive adjustments */
    @media (max-width: 768px) {
        .container-box {
            padding: 30px 20px;
        }
        .row > div {
            flex: 1 1 100%;
        }
    }
</style>
</asp:Content>


<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-box">
        <!-- Clean Logo + Title Header -->
        <div class="logo-header">
            <img src='<%= ResolveUrl("~/imgs/icon.jpg") %>' alt="Tournament Logo" />
            <h3>Tournament Registration Form</h3>
        </div>
        <!-- Personal Information -->
        <h5>Personal Information</h5>
        <hr class="mt-1 mb-3" />
        <div class="row">
            <div class="col-md-6 mb-3">
                <label>First Name <span class="required">*</span></label>
                <asp:RequiredFieldValidator ID="rfvFirstName" ControlToValidate="txtFirstName" CssClass="error-msg" Display="Dynamic" ErrorMessage="First Name is required." runat="server" />
                <asp:TextBox ID="txtFirstName" CssClass="form-control" runat="server" />
            </div>
            <div class="col-md-6 mb-3">
                <label>Last Name <span class="required">*</span></label>
                <asp:RequiredFieldValidator ID="rfvLastName" ControlToValidate="txtLastName" CssClass="error-msg" Display="Dynamic" ErrorMessage="Last Name is required." runat="server" />
                <asp:TextBox ID="txtLastName" CssClass="form-control" runat="server" />
            </div>
        </div>
        <div class="row">
            <div class="col-md-4 mb-3">
                <label>Date of Birth <span class="required">*</span></label>
                <asp:RequiredFieldValidator ID="rfvDOB" ControlToValidate="txtDOB" CssClass="error-msg" Display="Dynamic" ErrorMessage="Date of Birth is required." runat="server" />
                <asp:TextBox ID="txtDOB" CssClass="form-control" TextMode="Date" runat="server" />
            </div>
            <div class="col-md-4 mb-3">
                <label>Gender <span class="required">*</span></label>
                <asp:RequiredFieldValidator ID="rfvGender" ControlToValidate="ddlGender" InitialValue="" CssClass="error-msg" Display="Dynamic" ErrorMessage="Please select Gender." runat="server" />
                <asp:DropDownList ID="ddlGender" CssClass="form-select" runat="server">
                    <asp:ListItem Text="--Select--" Value="" />
                    <asp:ListItem Text="Male" Value="Male" />
                    <asp:ListItem Text="Female" Value="Female" />
                    <asp:ListItem Text="Other" Value="Other" />
                </asp:DropDownList>
            </div>
            <div class="col-md-4 mb-3">
                <label>Height (cm) <span class="required">*</span></label>
                <asp:RequiredFieldValidator ID="rfvHeight" ControlToValidate="txtHeight" CssClass="error-msg" Display="Dynamic" ErrorMessage="Height is required." runat="server" />
                <asp:TextBox ID="txtHeight" CssClass="form-control" runat="server" />
            </div>
        </div>
        <!-- Account Password -->
        <h5 class="mt-4">Account Password</h5>
        <hr class="mt-1 mb-3" />
        <div class="row">
            <div class="col-md-6 mb-3">
                <label>Password <span class="required">*</span></label>
                <asp:RequiredFieldValidator ID="rfvPassword" ControlToValidate="txtPassword" CssClass="error-msg" Display="Dynamic" ErrorMessage="Password is required." runat="server" />
                <asp:RegularExpressionValidator ID="revPassword" ControlToValidate="txtPassword" CssClass="error-msg" Display="Dynamic"
                    ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"
                    ErrorMessage="Password must be 8+ chars with uppercase, lowercase, number & special char." runat="server" />
                <asp:TextBox ID="txtPassword" CssClass="form-control" TextMode="Password" runat="server" />
            </div>
            <div class="col-md-6 mb-3">
                <label>Confirm Password <span class="required">*</span></label>
                <asp:RequiredFieldValidator ID="rfvConfirmPassword" ControlToValidate="txtConfirmPassword" CssClass="error-msg" Display="Dynamic" ErrorMessage="Confirm Password is required." runat="server" />
                <asp:CompareValidator ID="cvPasswordMatch" ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword" CssClass="error-msg" Display="Dynamic"
                    ErrorMessage="Passwords do not match." runat="server" />
                <asp:TextBox ID="txtConfirmPassword" CssClass="form-control" TextMode="Password" runat="server" />
            </div>
        </div>
        <!-- Contact Information -->
        <h5 class="mt-4">Contact Information</h5>
        <hr class="mt-1 mb-3" />
        <div class="row">
            <div class="col-md-6 mb-3">
                <label>Email <span class="required">*</span></label>
                <asp:RequiredFieldValidator ID="rfvEmail" ControlToValidate="txtEmail" CssClass="error-msg" Display="Dynamic" ErrorMessage="Email is required." runat="server" />
                <asp:RegularExpressionValidator ID="revEmail" ControlToValidate="txtEmail" CssClass="error-msg" Display="Dynamic"
                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ErrorMessage="Invalid email format." runat="server" />
                <asp:CustomValidator ID="cvEmailUnique" ControlToValidate="txtEmail" OnServerValidate="cvEmailUnique_ServerValidate" CssClass="error-msg" Display="Dynamic"
                    ErrorMessage="This email is already registered." runat="server" />
                <asp:TextBox ID="txtEmail" CssClass="form-control" TextMode="Email" runat="server" />
            </div>
            <div class="col-md-6 mb-3">
                <label>Phone Number <span class="required">*</span></label>
                <asp:RequiredFieldValidator ID="rfvPhone" ControlToValidate="txtPhone" CssClass="error-msg" Display="Dynamic" ErrorMessage="Phone Number is required." runat="server" />
                <asp:RegularExpressionValidator ID="revPhone" ControlToValidate="txtPhone" CssClass="error-msg" Display="Dynamic"
                    ValidationExpression="^\d{10}$" ErrorMessage="Phone must be exactly 10 digits." runat="server" />
                <asp:TextBox ID="txtPhone" CssClass="form-control" runat="server" />
            </div>
        </div>
        <!-- Address -->
        <div class="mb-3">
            <label>Address <span class="required">*</span></label>
            <asp:RequiredFieldValidator ID="rfvAddress1" ControlToValidate="txtAddress1" CssClass="error-msg" Display="Dynamic" ErrorMessage="Street Address is required." runat="server" />
            <asp:TextBox ID="txtAddress1" CssClass="form-control mb-2" runat="server" placeholder="Street Address" />
            <asp:TextBox ID="txtAddress2" CssClass="form-control" runat="server" placeholder="Street Address Line 2" />
        </div>
        <div class="row">
            <div class="col-md-4 mb-3">
                <label>City <span class="required">*</span></label>
                <asp:RequiredFieldValidator ID="rfvCity" ControlToValidate="txtCity" CssClass="error-msg" Display="Dynamic" ErrorMessage="City is required." runat="server" />
                <asp:TextBox ID="txtCity" CssClass="form-control" runat="server" />
            </div>
            <div class="col-md-4 mb-3">
                <label>State <span class="required">*</span></label>
                <asp:RequiredFieldValidator ID="rfvState" ControlToValidate="txtState" CssClass="error-msg" Display="Dynamic" ErrorMessage="State is required." runat="server" />
                <asp:TextBox ID="txtState" CssClass="form-control" runat="server" />
            </div>
            <div class="col-md-4 mb-3">
                <label>Postal Code <span class="required">*</span></label>
                <asp:RequiredFieldValidator ID="rfvPostal" ControlToValidate="txtPostal" CssClass="error-msg" Display="Dynamic" ErrorMessage="Postal Code is required." runat="server" />
                <asp:RegularExpressionValidator ID="revPostal" ControlToValidate="txtPostal" CssClass="error-msg" Display="Dynamic"
                    ValidationExpression="^\d{6}$" ErrorMessage="Postal Code must be 6 digits." runat="server" />
                <asp:TextBox ID="txtPostal" CssClass="form-control" runat="server" />
            </div>
        </div>
        <!-- Identification & Qualification -->
        <h5 class="mt-4">Identification & Qualification</h5>
        <hr class="mt-1 mb-3" />
        <div class="row">
            <div class="col-md-6 mb-3">
                <label>Highest Qualification</label>
                <asp:TextBox ID="txtQualification" CssClass="form-control" runat="server" placeholder="Optional" />
            </div>
            <div class="col-md-6 mb-3">
                <label>ID Proof Type <span class="required">*</span></label>
                <asp:RequiredFieldValidator ID="rfvIDType" ControlToValidate="ddlIDType" InitialValue="" CssClass="error-msg" Display="Dynamic" ErrorMessage="Please select ID Proof Type." runat="server" />
                <asp:DropDownList ID="ddlIDType" CssClass="form-select" runat="server">
                    <asp:ListItem Text="--Select--" Value="" />
                    <asp:ListItem Text="Aadhaar" Value="Aadhaar" />
                    <asp:ListItem Text="Voter ID" Value="VoterID" />
                    <asp:ListItem Text="PAN Card" Value="PAN" />
                    <asp:ListItem Text="Driving License" Value="DrivingLicense" />
                </asp:DropDownList>
            </div>
        </div>
        <div class="mb-3">
            <label>Upload ID Card <span class="required">*</span></label>
            <asp:RequiredFieldValidator ID="rfvIDUpload" ControlToValidate="FileUploadIDCard" CssClass="error-msg" Display="Dynamic" ErrorMessage="ID Card upload is required." runat="server" />
            <asp:FileUpload ID="FileUploadIDCard" CssClass="form-control" runat="server" />
        </div>
        <!-- Medical Information -->
        <h5 class="mt-4">Medical Information</h5>
        <hr class="mt-1 mb-3" />
        <label>Chronic Illnesses</label>
        <asp:TextBox ID="txtChronic" CssClass="form-control mb-3" runat="server" TextMode="MultiLine" Rows="2" placeholder="Optional"/>
        <label>Allergies</label>
        <asp:TextBox ID="txtAllergies" CssClass="form-control mb-3" runat="server" TextMode="MultiLine" Rows="2" placeholder="Optional"/>
        <label>Upload Medical Document</label>
        <asp:FileUpload ID="FileUploadMedical" CssClass="form-control mb-3" runat="server" />
        <!-- Physician & Insurance -->
        <h5 class="mt-4">Physician & Insurance (Optional)</h5>
        <hr class="mt-1 mb-3" />
        <div class="row">
            <div class="col-md-6 mb-3">
                <label>Physician First Name</label>
                <asp:TextBox ID="txtPhysicianName" CssClass="form-control" runat="server" placeholder="Optional" />
            </div>
            <div class="col-md-6 mb-3">
            <label>Physician Phone</label>
            <asp:TextBox ID="txtPhysicianPhone" CssClass="form-control" runat="server" placeholder="Optional" />
        </div>
        </div>
        <div class="row">
            
            <div class="col-md-6 mb-3">
                <label>Insurance Company</label>
                <asp:TextBox ID="txtInsuranceCompany" CssClass="form-control" runat="server" placeholder="Optional" />
            </div>
            <div class="col-md-6 mb-3">
            <label>Insurance Group #</label>
            <asp:TextBox ID="txtGroupNumber" CssClass="form-control" runat="server" placeholder="Optional" />
        </div>
       
            
        </div>
        <!-- Emergency Contact -->
        <h5 class="mt-4">Parent/Guardian & Emergency Contact</h5>
        <hr class="mt-1 mb-3" />
        <div class="row">
            <div class="col-md-6 mb-3">
                <label>Full Name <span class="required">*</span></label>
                <asp:RequiredFieldValidator ID="rfvGuardianName" ControlToValidate="txtGuardianName" CssClass="error-msg" Display="Dynamic" ErrorMessage="Guardian Name is required." runat="server" />
                <asp:TextBox ID="txtGuardianName" CssClass="form-control" runat="server" placeholder="Parent or Guardian Full Name" />
            </div>
            <div class="col-md-6 mb-3">
                <label>Relationship <span class="required">*</span></label>
                <asp:RequiredFieldValidator ID="rfvRelation" ControlToValidate="txtGuardianRelation" CssClass="error-msg" Display="Dynamic" ErrorMessage="Relationship is required." runat="server" />
                <asp:TextBox ID="txtGuardianRelation" CssClass="form-control" runat="server" placeholder="e.g., Mother, Father, Guardian" />
            </div>
        </div>
        <div class="row">
            <div class="col-md-6 mb-3">
                <label>Phone Number <span class="required">*</span></label>
                <asp:RequiredFieldValidator ID="rfvGuardianPhone" ControlToValidate="txtGuardianPhone" CssClass="error-msg" Display="Dynamic" ErrorMessage="Guardian Phone is required." runat="server" />
                <asp:RegularExpressionValidator ID="revGuardianPhone" ControlToValidate="txtGuardianPhone" CssClass="error-msg" Display="Dynamic"
                    ValidationExpression="^\d{10}$" ErrorMessage="Guardian Phone must be 10 digits." runat="server" />
                <asp:TextBox ID="txtGuardianPhone" CssClass="form-control" runat="server" placeholder="(000) 000-0000" />
            </div>
            <div class="col-md-6 mb-3">
                <label>Email Address</label>
                <asp:TextBox ID="txtGuardianEmail" CssClass="form-control" TextMode="Email" runat="server" placeholder="example@example.com" />
            </div>
        </div>
        <!-- Agreement -->
        <h5 class="mt-4">Athlete Agreement & Code of Conduct</h5>
        <hr class="mt-1 mb-3" />
        <div class="form-check mb-2">
            <asp:CheckBox ID="chkAgree1" runat="server" CssClass="form-check-input" />
            <label class="form-check-label fw-semibold" for="chkAgree1">
                I am physically able to take part in the tournament activities. <span class="required">*</span>
            </label>
        </div>
        <div class="form-check mb-2">
            <asp:CheckBox ID="chkAgree2" runat="server" CssClass="form-check-input" />
            <label class="form-check-label fw-semibold" for="chkAgree2">
                I understand there are risks involved and I will follow all safety and medical advice. <span class="required">*</span>
            </label>
        </div>
        <div class="form-check mb-2">
            <asp:CheckBox ID="chkAgree3" runat="server" CssClass="form-check-input" />
            <label class="form-check-label fw-semibold" for="chkAgree3">
                I will respect and obey all tournament rules and the athlete’s code of conduct. <span class="required">*</span>
            </label>
        </div>
        <asp:CustomValidator ID="cvAgreements" runat="server" OnServerValidate="cvAgreements_ServerValidate"
            ErrorMessage="You must agree to all statements." CssClass="error-msg" Display="Dynamic" />
        <!-- Signature and Date -->
        <div class="row mt-4">
            <div class="col-md-6 mb-3">
                <label>Date <span class="required">*</span></label>
                <asp:RequiredFieldValidator ID="rfvDate" ControlToValidate="txtAgreementDate" CssClass="error-msg" Display="Dynamic" ErrorMessage="Date is required." runat="server" />
                <asp:TextBox ID="txtAgreementDate" CssClass="form-control" TextMode="Date" runat="server" />
            </div>
            <div class="col-md-6 mb-3">
                <label>Signature (Full Name) <span class="required">*</span></label>
                <asp:RequiredFieldValidator ID="rfvSignature" ControlToValidate="txtSignature" CssClass="error-msg" Display="Dynamic" ErrorMessage="Signature is required." runat="server" />
                <asp:TextBox ID="txtSignature" CssClass="form-control" runat="server" placeholder="Athlete or Guardian Full Name" />
            </div>
        </div>
        <!-- Submit -->
        <div class="text-center mt-5">
            <asp:Label ID="lblStatus" runat="server"
                ForeColor="#e74c3c"
                Font-Bold="true"
                Visible="false"
                Style="display:block; margin-bottom:20px; font-size:1.1em;">
            </asp:Label>
            <asp:Button ID="btnSubmit" CssClass="btn-professional"
                Text="Submit Registration"
                runat="server"
                OnClick="btnSubmit_Click"
                CausesValidation="true" />
        </div>
    </div>
</asp:Content>