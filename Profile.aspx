<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="Marathone.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .profile-wrapper {
            max-width: 900px;
            margin: 25px auto;
            padding: 25px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        .profile-photo {
            width: 150px;
            height: 150px;
            border-radius: 50%;  

            
    

    /* FORCE WHITE BORDER */
            border: 4px solid #ffffff !important;

            /* REMOVE GREY EFFECTS */
            box-shadow: none !important;
            outline: none !important;
            background-color: #ffffff;

            object-fit: cover;
           
        }
        .btn-save {
            background: #77C7F3;
            color: #fff;
            border: none;
            padding: 12px 20px;
            width: 220px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 10px;
            cursor: pointer;
            transition: 0.25s ease;
            letter-spacing: 0.3px;
            font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
        }
        .btn-save:active {
            transform: scale(0.97);
        }
        .section-title {
            font-size: 20px;
            margin-top: 25px;
            font-weight: 600;
            position: relative;
            display: inline-block;
            padding-bottom: 3px;
        }
        .section-title::after {
            content: "";
            position: absolute;
            left: 0;
            bottom: 0;
            width: 100%;
            height: 2px;
            background: #e8f3ff;
            border-radius: 4px;
        }
        .id-preview {
            height: 150px;
            border: 2px solid #ccc;
            margin-top: 10px;
            object-fit: contain;
            background: #f9f9f9;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="profile-wrapper">
        <!-- Profile Photo -->
        <div class="text-center mb-4">
            <asp:Image ID="imgProfile" runat="server" 
                       CssClass="profile-photo" 
                       AlternateText="Profile Picture" />
            <div class="mt-2">
                <asp:FileUpload ID="FileUpload1" runat="server" CssClass="form-control" />
            </div>
        </div>

        <!-- Basic Information -->
        <div class="section-title">Basic Information</div>
        <div style="height:15px;"></div>
        <div class="row">
            <div class="col-md-6 mb-3">
                <label>Name</label>
                <asp:TextBox ID="txtName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-6 mb-3">
                <label>Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-6 mb-3">
                <label>Phone</label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-6 mb-3">
                <label>Date of Birth</label>
                <asp:TextBox ID="txtDOB" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
            </div>
        </div>

        <!-- Address -->
        <div class="section-title">Address</div>
        <div style="height:15px;"></div>
        <div class="row">
            <div class="col-md-12 mb-3">
                <label>Address Line</label>
                <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-4 mb-3">
                <label>City</label>
                <asp:TextBox ID="txtCity" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-4 mb-3">
                <label>State</label>
                <asp:TextBox ID="txtState" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-4 mb-3">
                <label>Country</label>
                <asp:TextBox ID="txtCountry" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-4 mb-3">
                <label>Pincode</label>
                <asp:TextBox ID="txtPincode" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
        </div>

        <!-- Personal Details -->
        <div class="section-title">Personal Details</div>
        <div style="height:15px;"></div>
        <div class="row">
            <div class="col-md-6 mb-3">
                <label>Nationality</label>
                <asp:TextBox ID="txtNationality" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
        </div>

        <!-- Emergency Contact -->
        <div class="section-title">Emergency Contact</div>
        <div style="height:15px;"></div>
        <div class="row">
            <div class="col-md-6 mb-3">
                <label>Guardian Name</label>
                <asp:TextBox ID="txtGuardianName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-6 mb-3">
                <label>Relationship</label>
                <asp:TextBox ID="txtGuardianRelationship" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-6 mb-3">
                <label>Guardian Phone</label>
                <asp:TextBox ID="txtGuardianPhone" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-6 mb-3">
                <label>Guardian Email</label>
                <asp:TextBox ID="txtGuardianEmail" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
        </div>

        <!-- ID Card -->
        <div class="section-title">ID Card</div>
        <div style="height:15px;"></div>
        <asp:Label ID="lblNoIDCard" runat="server" CssClass="text-muted" Text="No ID Card Uploaded Yet"></asp:Label>
        <br />
        <asp:Image ID="imgIDCard" runat="server" CssClass="id-preview" Visible="false" AlternateText="ID Card" />
        <div class="mt-2">
            <asp:FileUpload ID="FileUploadIDCard" runat="server" CssClass="form-control" />
        </div>
        <br />

        <!-- Save Button -->
        <div class="text-center mt-4">
            <asp:Button ID="btnSave" runat="server" CssClass="btn-save" Text="Save Profile" OnClick="btnSave_Click" />
        </div>
    </div>
</asp:Content>