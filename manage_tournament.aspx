<%@ Page Title="Manage Tournament" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true" CodeBehind="manage_tournament.aspx.cs"
    Inherits="Marathone.manage_tournament" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<h2 class="mb-3">Manage Tournaments</h2>

<asp:HiddenField ID="hfTournamentID" runat="server" />
<asp:Label ID="lblMsg" runat="server" Font-Bold="true" />

<hr />

<!-- ================= TOURNAMENT LIST ================= -->
<h4>All Tournaments</h4>

<asp:GridView ID="gvTournaments" runat="server"
    AutoGenerateColumns="False"
    DataKeyNames="TournamentID"
    OnRowCommand="gvTournaments_RowCommand"
    CssClass="table table-striped table-hover">

    <Columns>
        <asp:BoundField DataField="TournamentName" HeaderText="Tournament" />
        <asp:BoundField DataField="TournamentDate" HeaderText="Date"
            DataFormatString="{0:yyyy-MM-dd}" />
        <asp:BoundField DataField="Status" HeaderText="Status" />

        <asp:TemplateField HeaderText="Actions">
            <ItemTemplate>
                <asp:LinkButton runat="server"
                    Text="View Members"
                    CommandName="ViewMembers"
                    CommandArgument='<%# Eval("TournamentID") %>'
                    CssClass="btn btn-sm btn-outline-primary me-1" />

                <asp:LinkButton runat="server"
                    Text="Add Members"
                    CommandName="AddMembers"
                    CommandArgument='<%# Eval("TournamentID") %>'
                    CssClass="btn btn-sm btn-outline-success me-1" />

                <asp:LinkButton runat="server"
                    Text="Delete"
                    CommandName="DeleteTournament"
                    CommandArgument='<%# Eval("TournamentID") %>'
                    OnClientClick="return confirm('Delete this tournament?');"
                    CssClass="btn btn-sm btn-outline-danger" />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>

<hr />

<!-- ================= ADD MEMBERS ================= -->
<h4>Add Members</h4>


<br /><br />

<!-- Popup Panel -->
<asp:Panel ID="pnlUsers" runat="server" Visible="false" CssClass="card p-3">

    <h5>Select Users to Add</h5>

    <asp:GridView ID="gvUsers" runat="server"
        AutoGenerateColumns="False"
        DataKeyNames="UserID"
        CssClass="table table-bordered table-sm">

        <Columns>
            <asp:TemplateField HeaderText="Select">
                <ItemTemplate>
                    <asp:CheckBox ID="chkUser" runat="server" />
                </ItemTemplate>
            </asp:TemplateField>

            <asp:BoundField DataField="Name" HeaderText="Name" />
            <asp:BoundField DataField="Email" HeaderText="Email" />
        </Columns>
    </asp:GridView>

    <asp:Button ID="btnAddSelected" runat="server"
        Text="Add Selected Members"
        CssClass="btn btn-success mt-2"
        OnClick="btnAddSelected_Click" />
</asp:Panel>

<hr />

<!-- ================= MEMBERS GRID ================= -->
<h4>Tournament Members</h4>

<asp:GridView ID="gvMembers" runat="server"
    AutoGenerateColumns="False"
    DataKeyNames="TournamentMemberID"
    OnRowCommand="gvMembers_RowCommand"
    CssClass="table table-striped table-hover">

    <Columns>
        <asp:BoundField DataField="TournamentName" HeaderText="Tournament" />
        <asp:BoundField DataField="UserID" HeaderText="User ID" />
        <asp:BoundField DataField="MemberName" HeaderText="Member Name" />
        <asp:BoundField DataField="EPC" HeaderText="RFID EPC" />

        <asp:TemplateField HeaderText="Action">
            <ItemTemplate>
                <asp:LinkButton ID="lnkRemove" runat="server"
                    Text="Remove"
                    CommandName="RemoveMember"
                    CommandArgument='<%# Eval("TournamentMemberID") %>'
                    OnClientClick="return confirm('Remove this member?');"
                    CssClass="btn btn-sm btn-danger" />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>

</asp:Content>
