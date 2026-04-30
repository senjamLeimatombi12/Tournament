<%@ Page Title="Create Tournament" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true" CodeBehind="create_tournament.aspx.cs"
    Inherits="Marathone.create_tournament" %>

<asp:Content ID="ContentHead" ContentPlaceHolderID="head" runat="server">
    <style>
        .container-box {
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            margin-top: 20px;
        }
        .form-control {
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        label {
            font-weight: 600;
            margin-top: 12px;
            display: block;
        }
        .btn-main {
            background-color: #77C7F3;
            color: #fff;
            padding: 10px 22px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
        }
        .btn-danger {
            background-color: #e74c3c;
        }
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .table th, .table td {
            border: 1px solid #ddd;
            padding: 10px;
        }
        .table th {
            background-color: #77C7F3;
            color: #fff;
        }
    </style>
</asp:Content>

<asp:Content ID="ContentMain" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="container-box">

    <h2>Create Tournament</h2>
    <hr />

    <asp:Label ID="lblMessage" runat="server" Font-Bold="true" />
    <asp:HiddenField ID="hfTournamentID" runat="server" />

    <label>Tournament Name *</label>
    <asp:TextBox ID="txtTournamentName" runat="server" CssClass="form-control" Width="400px" />

    <label>Venue *</label>
    <asp:TextBox ID="txtVenue" runat="server" CssClass="form-control" Width="400px" />

    <label>Tournament Date *</label>
    <asp:TextBox ID="txtTournamentDate" runat="server" TextMode="Date"
        CssClass="form-control" Width="200px" />

    <div style="display:flex; gap:20px;">
        <div>
            <label>Min Age</label>
            <asp:TextBox ID="txtMinAge" runat="server" TextMode="Number"
                CssClass="form-control" Width="100px" />
        </div>
        <div>
            <label>Max Age</label>
            <asp:TextBox ID="txtMaxAge" runat="server" TextMode="Number"
                CssClass="form-control" Width="100px" />
        </div>
    </div>

    <label>Distance (meters) *</label>
    <asp:TextBox ID="txtDistance" runat="server" TextMode="Number"
        CssClass="form-control" Width="200px" />

    <label>Status *</label>
    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control" Width="250px">
        <asp:ListItem Text="Upcoming" />
        <asp:ListItem Text="Open for Registration" />
        <asp:ListItem Text="Ongoing" />
        <asp:ListItem Text="Completed" />
        <asp:ListItem Text="Cancelled" />
    </asp:DropDownList>

    <br /><br />

    <asp:Button ID="btnSave" runat="server" Text="Create Tournament"
        CssClass="btn-main" OnClick="btnSave_Click" />

    <asp:Button ID="btnClear" runat="server" Text="Clear"
        CssClass="btn-main btn-danger" OnClick="btnClear_Click" />

    <hr style="margin:30px 0;" />

    <h3>Existing Tournaments</h3>

    <asp:GridView ID="gvTournaments" runat="server"
        AutoGenerateColumns="False"
        DataKeyNames="TournamentID"
        CssClass="table"
        OnRowCommand="gvTournaments_RowCommand">

        <Columns>
            <asp:BoundField DataField="TournamentName" HeaderText="Tournament" />
            <asp:BoundField DataField="Venue" HeaderText="Venue" />
            <asp:BoundField DataField="DistanceMeters" HeaderText="Distance (m)" />
            <asp:BoundField DataField="MinAge" HeaderText="Min Age" />
            <asp:BoundField DataField="MaxAge" HeaderText="Max Age" />
            <asp:BoundField DataField="TournamentDate" HeaderText="Date"
                DataFormatString="{0:yyyy-MM-dd}" />
            <asp:BoundField DataField="Status" HeaderText="Status" />

            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:Button ID="btnEdit" runat="server"
                        Text="Edit"
                        CssClass="btn-main"
                        CommandName="EditTournament"
                        CommandArgument='<%# Eval("TournamentID") %>'
                         />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

</div>
</asp:Content>
