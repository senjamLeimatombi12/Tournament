<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Team_create.aspx.cs" Inherits="Marathone.Team_create" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  <style>
      /* ONLY THIS PART IS NEW – for the floating button */
      .top-right-btn {
          position: fixed;
          top: 100px;        /* ~1 inch lower from the very top */
          right: 30px;
          z-index: 1000;
      }

      /* Your original styles – unchanged */
      .btn-professional {
            background-color:#77C7F3;
            color: #ffffff;
            font-family: 'Segoe UI', Arial, sans-serif;
            font-size: 15px;
            font-weight: 600;
            padding: 10px 22px;
            border: none;
            border-radius: 9px;
            cursor: pointer;
            transition: background-color 0.2s ease, box-shadow 0.2s ease;
            margin-top: 16px;
        }
         
        .btn-professional:hover {
            background-color: #5ab5e8;
            box-shadow: 0 6px 20px rgba(119,199,243,0.5);
        }
       
       
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .table th, .table td {
            border: 1px solid #ddd;
            padding: 8px;
        }
        .table th {
            background-color: #f2f2f2;
            text-align: left;
        }
        .btn {
            margin: 5px;
            background-color:#77C7F3
        }
        body, html, form {
            background-color: white !important;
        }
  </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- ONLY THIS IS NEW – Floating View All Teams button -->
    <div class="top-right-btn">
        <asp:Button ID="Button2" runat="server" 
            Text="View All Teams" 
            CssClass="btn-professional" 
            OnClick="btnCreateTeam1_Click" />
    </div>

    <div style="background:white; padding:20px;">
        <h2>Create / Manage Team</h2>
        <div>
            <label>Team Name:</label>
            <asp:TextBox ID="txtTeamName" runat="server" CssClass="form-control"></asp:TextBox><br />
            
            <label>Date:</label>
            <asp:TextBox ID="txtDate" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox><br />
            
            <label>Min Age:</label>
            <asp:TextBox ID="txtMinAge" runat="server" CssClass="form-control" Width="100px"></asp:TextBox>
            
            <label>Max Age:</label>
            <asp:TextBox ID="txtMaxAge" runat="server" CssClass="form-control" Width="100px"></asp:TextBox>
            
            <div style="height:5px;"></div>
            
            <asp:Button ID="btnFilter"
                runat="server"
                Text="Filter Members"
                CssClass="btn-professional"
                OnClick="btnFilter_Click" />
        </div>

        <hr />

        <h4>Eligible Participants</h4>
        <asp:GridView ID="gvParticipants"
            runat="server"
            AutoGenerateColumns="False"
            CssClass="table"
            DataKeyNames="ID">
            <Columns>
                <asp:TemplateField HeaderText="Select">
                    <ItemTemplate>
                        <asp:CheckBox ID="chkSelect" runat="server" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="ID" HeaderText="User ID" ReadOnly="True" />
                <asp:BoundField DataField="Name" HeaderText="Name" />
                <asp:BoundField DataField="Age" HeaderText="Age" />
                <asp:BoundField DataField="RFID" HeaderText="RFID" />
            </Columns>
        </asp:GridView>

        <asp:Button ID="btnCreateTeam" runat="server" 
             Text="Create Team" 
             CssClass="btn-professional" 
             OnClick="btnCreateTeam_Click" />

        <hr />

        <h4>Team Members</h4>
        <asp:GridView ID="gvTeamMembers" runat="server" 
            AutoGenerateColumns="False" 
            CssClass="table" 
            OnRowCommand="gvTeamMembers_RowCommand">
            <Columns>
                <asp:BoundField DataField="Name" HeaderText="Name" />
                <asp:BoundField DataField="Age" HeaderText="Age" />
                <asp:BoundField DataField="RFID" HeaderText="RFID" />
                <asp:ButtonField CommandName="DeleteMember" Text="Delete" ButtonType="Button" />
            </Columns>
        </asp:GridView>

        <asp:Label ID="lblMessage" runat="server" ForeColor="Green"></asp:Label>
    </div>

</asp:Content>