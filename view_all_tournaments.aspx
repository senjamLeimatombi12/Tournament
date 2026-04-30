<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true"
    CodeBehind="view_all_tournaments.aspx.cs" Inherits="Marathone.view_all_tournaments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        
        .top-right-btn {
            position: fixed;
            top: 100px;
            right: 30px;
            z-index: 1000;
        }

       
        .btn-professional {
            background-color: #77C7F3;
            color: #ffffff;
            font-family: 'Segoe UI', Arial, sans-serif;
            font-size: 15px;
            font-weight: 600;
            padding: 10px 22px;
            border: none;
            border-radius: 9px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(119,199,243,0.4);
        }
        .btn-professional:hover {
            background-color: #5ab5e8;
            box-shadow: 0 8px 25px rgba(119,199,243,0.6);
            transform: translateY(-2px);
        }

        .btn-delete {
            background-color: #e74c3c !important;
        }
        .btn-delete:hover {
            background-color: #c0392b !important;
        }

       
        .table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 20px;
            font-size: 14.5px;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.06);
        }
        .table th {
            background-color: #77C7F3;
            color: white;
            font-weight: 600;
            padding: 14px 12px;
            text-align: center;
        }
        .table td {
            padding: 12px;
            text-align: center;
            background-color: #ffffff;
            border-bottom: 1px solid #f0f0f0;
        }
        .table tr:nth-child(even) td {
            background-color: #f9fbff;
        }
        .table tr:hover td {
            background-color: #eef5ff;
        }

        /* Container box - same as create page */
        .container-box {
            background: white;
            padding: 35px;
            border-radius: 14px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.09);
            margin-top: 20px;
            margin-bottom: 40px;
        }

        h2, h3, h4 {
            color: #2c3e50;
            font-weight: 600;
        }
        h2 {
            font-size: 28px;
            margin-bottom: 10px;
        }
        hr {
            border-top: 3px solid #77C7F3;
            margin: 30px 0;
            border-radius: 3px;
        }

        .total-members-label {
            font-size: 18px;
            font-weight: 600;
            color: #2c3e50;
            background: #e8f4fd;
            padding: 12px 20px;
            border-radius: 10px;
            display: inline-block;
            box-shadow: 0 3px 10px rgba(119,199,243,0.2);
        }

        body, html, form {
            background-color: #f8fbff !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

 
    <div class="top-right-btn">
        <asp:Button ID="btnBack" runat="server"
            Text="Create New Tournament"
            CssClass="btn-professional"
            PostBackUrl="~/create_tournament.aspx" />
    </div>

    <div class="container-box">
        <h2>All Tournaments</h2>
        <hr />

        <asp:GridView ID="gvTournaments" runat="server" AutoGenerateColumns="false"
            CssClass="table" AllowPaging="true" PageSize="10"
            EmptyDataText="<div style='padding:40px; text-align:center; color:#95a5a6; font-size:16px;'>No tournaments found</div>"
            OnPageIndexChanging="gvTournaments_PageIndexChanging"
            OnSelectedIndexChanged="gvTournaments_SelectedIndexChanged"
            OnRowCommand="gvTournaments_RowCommand"
            GridLines="None">
            
            <Columns>
                <asp:BoundField DataField="TournamentID" Visible="false" />
                
                <asp:BoundField DataField="TournamentName" HeaderText="Tournament Name">
                    <ItemStyle Font-Bold="true" />
                </asp:BoundField>
                
                <asp:BoundField DataField="Venue" HeaderText="Venue" />
                <asp:BoundField DataField="TournamentDate" HeaderText="Date" 
                    DataFormatString="{0:dd MMM yyyy}" />

               
                <asp:TemplateField HeaderText="Teams">
                    <ItemTemplate>
                        <asp:Button ID="btnView" runat="server" Text="View Teams"
                            CssClass="btn-professional"
                            Style="padding:8px 16px; font-size:14px;"
                            CommandName="ViewTournament"
                            CommandArgument='<%# Eval("TournamentID") %>' />
                    </ItemTemplate>
                </asp:TemplateField>

                
                <asp:TemplateField HeaderText="Delete">
                    <ItemTemplate>
                        <asp:Button ID="btnDelete" runat="server" Text="Delete"
                            CssClass="btn-professional btn-delete"
                            Style="padding:8px 16px; font-size:14px;"
                            CommandName="DeleteTournament"
                            CommandArgument='<%# Eval("TournamentID") %>'
                            OnClientClick="return confirm('Are you sure you want to delete this tournament?');" />
                    </ItemTemplate>
                </asp:TemplateField>

               
                <asp:TemplateField HeaderText="View All Members">
                    <ItemTemplate>
                        <asp:Button ID="btnViewAllMembers" runat="server"
                            Text="View All Members"
                            CssClass="btn-professional"
                            Style="padding:8px 16px; font-size:14px; background-color:#27ae60;"
                            CommandName="ViewAllMembers"
                            OnClick="btnViewAllMembers_Click"
                            CommandArgument='<%# Eval("TournamentID") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>

        <br />
        <h3>All Total Members</h3>
        <asp:Label ID="lblTotalMembers" runat="server"
            CssClass="total-members-label"
            Text="Total Members: "></asp:Label>

        <hr />

        <h3>Teams Participating</h3>
        <asp:GridView ID="gvTournamentDetails" runat="server" AutoGenerateColumns="false"
            CssClass="table" DataKeyNames="TeamID" OnRowCommand="gvTournamentDetails_RowCommand">
            <Columns>
                <asp:BoundField DataField="TeamName" HeaderText="Team Name" />
                <asp:TemplateField HeaderText="Members">
                    <ItemTemplate>
                        <asp:Button ID="btnViewMembers" runat="server"
                            Text="View Members"
                            CssClass="btn-professional"
                            Style="padding:8px 16px; font-size:14px; background-color:#3498db;"
                            CommandName="ViewMembers"
                            CommandArgument='<%# ((GridViewRow)Container).RowIndex %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <div style="text-align:center; padding:40px; color:#95a5a6;">
                    No teams participating yet.
                </div>
            </EmptyDataTemplate>
        </asp:GridView>

        <hr />

       

        <asp:GridView ID="gvMembers" runat="server" AutoGenerateColumns="false"
            CssClass="table">
            <Columns>
                <asp:BoundField DataField="MemberID" HeaderText="Member ID" />
                <asp:BoundField DataField="Name" HeaderText="Name" />
                <asp:BoundField DataField="Age" HeaderText="Age" />
                <asp:BoundField DataField="RFID" HeaderText="RFID Tag" />
            </Columns>
            <EmptyDataTemplate>
                <div style="text-align:center; padding:40px; color:#95a5a6;">
                    No members in this team.
                </div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>

</asp:Content>