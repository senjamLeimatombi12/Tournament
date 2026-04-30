<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="User_Registration.aspx.cs" Inherits="Marathone.User_Registration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Customer Sign Up</title>
    <style>
    .btn-lightblue {
        background-color: #77C7F3 !important;   /* Pale Light Blue */
        border: none !important;
        color: #000 !important;
        padding: 12px;
        border-radius: 6px;
        font-weight: bold;
        width: 100%;
        font-size: 16px;
        font-weight: 600;
        font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
        }
    <style>
    body {
        background: linear-gradient(135deg, #eef7ff, #ffffff);
        font-family: 'Segoe UI', sans-serif;
    }

    .register-card {
        border-radius: 20px;
        box-shadow: 0 25px 60px rgba(0, 98, 255, 0.08);
        background: #fff;
        border: none;
        padding: 20px;
        animation: fadeIn 0.6s ease-in-out;
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(15px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .form-control, .form-select {
        border-radius: 12px !important;
        padding: 12px 14px;
        border: 1px solid #dbeafe;
        transition: all 0.2s ease-in-out;
        font-size: 15px;
    }

    .form-control:focus, .form-select:focus {
        border-color: #4dabff;
        box-shadow: 0 0 0 3px rgba(77, 171, 255, 0.15);
    }

    label {
        font-weight: 600;
        margin-bottom: 6px;
        color: #1e3a8a;
        font-size: 16px;
    }

    .title-text {
        font-size: 26px;
        font-weight: 700;
        color: #0d6efd;
        letter-spacing: 0.5px;
    }

    .subtitle-text {
        color: #64748b;
        font-size: 16px;
    }

    .btn-signup {
        background: linear-gradient(135deg, #0d6efd, #0dcaf0);
        color: #fff !important;
        border-radius: 30px;
        padding: 14px 28px;
        font-size: 16px;
        font-weight: 600;
        width: 100%;
        border: none;
        transition: all 0.25s ease-in-out;
    }

    .btn-signup:hover {
        transform: translateY(-1px);
        box-shadow: 0 12px 30px rgba(13, 110, 253, 0.35);
    }

    .card-header-section {
        text-align: center;
        padding-bottom: 15px;
        margin-bottom: 25px;
        border-bottom: 1px solid #eef2ff;
    }

    .profile-img {
        width: 90px;
        height: 90px;
        border-radius: 50%;
        object-fit: cover;
        box-shadow: 0 10px 30px rgba(0,0,0,0.08);
    }

    .form-grid {
        row-gap: 18px;
    }
</style>

   


    <script type="text/javascript">
        // Show/hide ID fields based on nationality
        function toggleIDFields() {
            var nationality = document.getElementById('<%= ddlNationality.ClientID %>').value;
            var indianDiv = document.getElementById("indianIDSection");
            var foreignDiv = document.getElementById("foreignIDSection");

            if (nationality === "Indian") {
                indianDiv.style.display = "flex";
                foreignDiv.style.display = "none";
            } else if (nationality === "Foreigner") {
                indianDiv.style.display = "none";
                foreignDiv.style.display = "flex";
            } else {
                indianDiv.style.display = "none";
                foreignDiv.style.display = "none";
            }
        }

        // Run when page reloads or edits occur
        window.onload = function () {
            toggleIDFields();
        };
    </script>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   <body class="no-sidebar">
    <div class="container mt-4 mb-5">
        <div class="row">
            <div class="col-md-8 mx-auto">
                <div class="card shadow border-0 rounded-4">
                    <div class="card register-card">
                    <div class="card-body px-md-5 py-4">

                        <!-- Header -->
                        <div class="card-header-section">
                            <img src="imgs/profile.jpg" class="profile-img" alt="Logo" />
                            <h2 class="title-text mt-3">Create Your Account</h2>
                            <p class="subtitle-text">Fill in your details to get started</p>
                        </div>

                        <!-- Full Name / Email -->
                        <div class="row">
                            <div class="col-md-6">
                                <label>Full Name</label>
                                <asp:TextBox CssClass="form-control" ID="TextBox1" runat="server" placeholder="Enter full name"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label>Email ID</label>
                                <asp:TextBox CssClass="form-control" ID="TextBox4" runat="server" placeholder="Enter email address" TextMode="Email"></asp:TextBox>
                            </div>
                        </div>

                        <!-- Contact / DOB -->
                        <div class="row mt-3">
                            <div class="col-md-6">
                                <label>Contact No</label>
                                <asp:TextBox CssClass="form-control" ID="TextBox2" runat="server" placeholder="Enter contact number" TextMode="Number"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label>Date of Birth</label>
                                <asp:TextBox CssClass="form-control" ID="TextBox3" runat="server" TextMode="Date"></asp:TextBox>
                            </div>
                        </div>

                        <!-- State / Country / Pin -->
                        <div class="row mt-3">
                            <div class="col-md-4">
                                <label>State</label>
                                <asp:TextBox CssClass="form-control" ID="TextBox5" runat="server" placeholder="State"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label>Country</label>
                                <asp:TextBox CssClass="form-control" ID="TextBox6" runat="server" placeholder="Country"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label>Pin Code</label>
                                <asp:TextBox CssClass="form-control" ID="TextBox7" runat="server" placeholder="Pin Code" TextMode="Number"></asp:TextBox>
                            </div>
                        </div>

                        <!-- Address -->
                        <div class="row mt-3">
                            <div class="col">
                                <label>Full Address</label>
                                <asp:TextBox CssClass="form-control" ID="TextBox8" runat="server" placeholder="Enter full address" TextMode="MultiLine"></asp:TextBox>
                            </div>
                        </div>

                        <!-- Nationality -->
                        <div class="row mt-3">
                            <div class="col-md-6">
                                <label>Nationality</label>
                                <asp:DropDownList CssClass="form-control" ID="ddlNationality" runat="server" onchange="toggleIDFields()">
                                    <asp:ListItem Text="-- Select --" Value="" />
                                    <asp:ListItem Text="Indian" Value="Indian" />
                                    <asp:ListItem Text="Foreigner" Value="Foreigner" />
                                </asp:DropDownList>
                            </div>
                        </div>

                        <!-- Govt ID for Indians -->
                        <div class="row mt-3 align-items-end" id="indianIDSection" style="display:none;">
                            <div class="col-md-6">
                                <label>Government ID Type</label>
                                <asp:DropDownList CssClass="form-control" ID="ddlGovtIDType" runat="server">
                                    <asp:ListItem Text="Aadhaar" Value="Aadhaar" />
                                    <asp:ListItem Text="PAN" Value="PAN" />
                                    <asp:ListItem Text="Driving License" Value="DrivingLicense" />
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-6">
                                <label>ID Number</label>
                                <asp:TextBox CssClass="form-control" ID="txtGovtID" runat="server" placeholder="Enter Government ID"></asp:TextBox>
                            </div>
                        </div>

                        <!-- Passport for Foreigners -->
                        <div class="row mt-3" id="foreignIDSection" style="display:none;">
                            <div class="col-md-12">
                                <label>Passport Number</label>
                                <asp:TextBox CssClass="form-control" ID="txtPassport" runat="server" placeholder="Enter Passport Number"></asp:TextBox>
                            </div>
                        </div>

                        <!-- Username / Password -->
                        <div class="row mt-3">
                            <div class="col-md-6">
                                <label>Username</label>
                                <asp:TextBox CssClass="form-control" ID="TextBox9" runat="server" placeholder="Choose username"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label>Password</label>
                                <asp:TextBox CssClass="form-control" ID="TextBox10" runat="server" placeholder="Enter password" TextMode="Password"></asp:TextBox>
                            </div>
                        </div>

                        <!-- Submit -->
                        <div class="mt-4">
                        <asp:Button CssClass="btn-signup" ID="Button1" runat="server" Text="Create Account" OnClick="Button1_Click" />
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
        </body>
</asp:Content>
