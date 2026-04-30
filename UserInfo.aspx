<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="UserInfo.aspx.cs" Inherits="Marathone.UserInfo" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     


    <style>
        body {
            background: #f0f2f5;
        }
        .cover-container {
                position: relative;
                width: 100%;
                height: 450px;           /* Keep cover height */
                overflow: visible;       /* Important: Allows overlap without cutting */
                box-shadow: 0 2px 4px rgba(0,0,0,0.2);
            }

            .profile-pic-timeline {
                position: absolute;
                bottom: -90px;           /* Brings the full pic down into view */
                left: 50px;
                width: 180px;            /* Slightly larger for better look */
                height: 180px;
                border: 5px solid white;
                border-radius: 8px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.5);
                object-fit: cover;
                background: white;
                z-index: 10;
            }

            .profile-name-timeline {
                position: absolute;
                bottom: 50px;            /* Aligned nicely next to full pic */
                left: 260px;
                font-size: 40px;
                font-weight: bold;
                color: white;
                text-shadow: 0 2px 6px rgba(0,0,0,0.8);
            }

            .tabs-timeline {
                background: white;
                border-bottom: 1px solid #ddd;
                padding: 10px 0;
                text-align: center;
                margin-top: 100px;       /* Gives full space for the overlapping pic */
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
                position: relative;
                z-index: 5;
            }
         
            .profile-container {
            max-width: 900px;
            margin: 30px auto;
            padding: 25px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 0 20px rgba(0,0,0,0.08);
        }

        .profile-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .profile-pic {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #e6e6e6;
        }

        .title-section {
            font-size: 20px;
            font-weight: 600;
            margin-top: 30px;
            position: relative;
            padding-bottom: 5px;
            display: inline-block;
        }

        .title-section::after {
            content: "";
            position: absolute;
            left: 0;
            bottom: 0;
            height: 3px;
            width: 100%;
            background: #d9eaff;
            border-radius: 5px;
        }

        .btn-save {
            background: #1877f2;
            color: #fff;
            border: none;
            padding: 12px 20px;
            width: 240px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 10px;
            transition: 0.3s;
        }

        .btn-save:hover {
            background: #145ecc;
        }

        .id-preview {
            height: 160px;
            border: 2px solid #ccc;
            margin-top: 10px;
            border-radius: 8px;
            object-fit: contain;
        }
    </style>

</asp:Content>


<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        body { background: #f0f2f5; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; }
        .profile-header {
            background: white;
            padding: 30px;
            text-align: center;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .profile-pic-large {
            width: 220px;
            height: 220px;
            border-radius: 50%;
            object-fit: cover;
            border: 6px solid white;
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
            margin-bottom: 20px;
        }
        .profile-name {
            font-size: 36px;
            font-weight: bold;
            color: #1c1e21;
            margin-bottom: 10px;
        }
        .tabs-timeline {
            background: white;
            border-bottom: 1px solid #ddd;
            padding: 12px 0;
            text-align: center;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .tabs-timeline a {
            display: inline-block;
            padding: 12px 25px;
            margin: 0 10px;
            font-weight: bold;
            color: #333;
            text-decoration: none;
            font-size: 16px;
        }
        .tabs-timeline a.active {
            color: #3b5998;
            border-bottom: 4px solid #3b5998;
        }
        .about-container {
            background: white;
            padding: 30px;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .section-title {
            font-size: 20px;
            font-weight: bold;
            color: #1c1e21;
            border-bottom: 2px solid #3b5998;
            padding-bottom: 10px;
            margin-bottom: 25px;
        }
        .info-row {
            margin-bottom: 18px;
            font-size: 16px;
        }
        .info-label {
            display: inline-block;
            width: 180px;
            font-weight: bold;
            color: #333;
        }
        .info-value {
            color: #1c1e21;
        }
        .info-value:empty::before {
            content: "Not specified";
            color: #999;
            font-style: italic;
        }
    </style>

    <!-- Profile Header: Large Pic + Name -->
    <div class="profile-header">
        <asp:Image ID="imgProfile" runat="server" CssClass="profile-pic-large" />
        <div class="profile-name">
            <asp:Literal ID="litName" runat="server"></asp:Literal>
        </div>
    </div>

    <!-- Tabs -->
    <div class="tabs-timeline">
        <a href="#">Timeline</a>
        <a href="#" class="active">About</a>
       
        <a href="Profile.aspx" style="float:right; background:#f6f7f9; color:#3b5998; border-radius:6px;">Edit Profile</a>
    </div>

    <div class="container">
        <div class="row">
            <!-- Main About Info -->
            <div class="col-md-8">
                <div class="about-container">
                    <div class="section-title">About</div>

                    <h5 style="color:#3b5998; margin-top:20px;">Basic Information</h5>
                    <div class="info-row">
                        <span class="info-label">Name:</span>
                        <span class="info-value"><asp:Literal ID="litName2" runat="server"></asp:Literal></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Email:</span>
                        <span class="info-value"><asp:Literal ID="litEmail" runat="server"></asp:Literal></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Phone:</span>
                        <span class="info-value"><asp:Literal ID="litPhone" runat="server"></asp:Literal></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Date of Birth:</span>
                        <span class="info-value"><asp:Literal ID="litDOB" runat="server"></asp:Literal></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Nationality:</span>
                        <span class="info-value"><asp:Literal ID="litNationality" runat="server"></asp:Literal></span>
                    </div>

                    <h5 style="color:#3b5998; margin-top:40px;">Address</h5>
                    <div class="info-row">
                        <span class="info-label">Address:</span>
                        <span class="info-value"><asp:Literal ID="litAddress" runat="server"></asp:Literal></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">City:</span>
                        <span class="info-value"><asp:Literal ID="litCity" runat="server"></asp:Literal></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">State:</span>
                        <span class="info-value"><asp:Literal ID="litState" runat="server"></asp:Literal></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Country:</span>
                        <span class="info-value"><asp:Literal ID="litCountry" runat="server"></asp:Literal></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Pincode:</span>
                        <span class="info-value"><asp:Literal ID="litPincode" runat="server"></asp:Literal></span>
                    </div>

                    <h5 style="color:#3b5998; margin-top:40px;">Emergency Contact</h5>
                    <div class="info-row">
                        <span class="info-label">Guardian Name:</span>
                        <span class="info-value"><asp:Literal ID="litGuardianName" runat="server"></asp:Literal></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Relationship:</span>
                        <span class="info-value"><asp:Literal ID="litGuardianRelationship" runat="server"></asp:Literal></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Guardian Phone:</span>
                        <span class="info-value"><asp:Literal ID="litGuardianPhone" runat="server"></asp:Literal></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Guardian Email:</span>
                        <span class="info-value"><asp:Literal ID="litGuardianEmail" runat="server"></asp:Literal></span>
                    </div>
                </div>
            </div>

            <!-- Right: ID Card -->
            <div class="col-md-4">
                <div class="about-container">
                    <div class="section-title">ID Card</div>
                    <asp:Label ID="lblNoIDCard" runat="server" Text="No ID Card Uploaded" CssClass="text-muted d-block mb-3" />
                    <asp:Image ID="imgIDCard" runat="server" CssClass="img-fluid" style="max-height:450px; border:1px solid #ddd; border-radius:8px;" />
                </div>
            </div>
        </div>

        <!-- Edit Button -->
        <div class="text-center my-5">
            <a href="EditProfile.aspx" class="btn btn-primary btn-lg px-5 py-3" 
               style="background:#3b5998; border:none; font-size:18px; text-decoration:none;">
                Edit Profile
            </a>
        </div>
    </div>
</asp:Content>