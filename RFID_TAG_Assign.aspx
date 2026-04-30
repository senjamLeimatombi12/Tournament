<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="RFID_TAG_Assign.aspx.cs"
    Inherits="Marathone.RFID_TAG_Assign" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>RFID Management</title>
    <style>
        table { width:100%; border-collapse:collapse; background:#fff; }
        th,td { padding:8px; border:1px solid #ccc; }
        .btn { padding:6px 10px; cursor:pointer; }
        .assign,.delete { background:#77C7F3; color:white; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<h2>RFID Management</h2>

<!-- ===== MEMBERS WITH RFID ===== -->
<h3>Members with RFID</h3>

<asp:GridView ID="gvWithRFID" runat="server"
    AutoGenerateColumns="False"
    DataKeyNames="TournamentMemberID,TournamentID"
    OnRowEditing="gvWithRFID_RowEditing"
    OnRowUpdating="gvWithRFID_RowUpdating"
    OnRowCancelingEdit="gvWithRFID_RowCancelingEdit"
    OnRowCommand="gv_RowCommand">

    <Columns>
        <asp:BoundField DataField="TournamentMemberID" HeaderText="ID" ReadOnly="true" />
        <asp:BoundField DataField="MemberName" HeaderText="Name" ReadOnly="true" />

        <asp:TemplateField HeaderText="RFID">
            <ItemTemplate><%# Eval("EPC") %></ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="txtEditRFID" runat="server"
                    Text='<%# Bind("EPC") %>' />
            </EditItemTemplate>
        </asp:TemplateField>

        <asp:CommandField ShowEditButton="true" />

        <asp:TemplateField>
            <ItemTemplate>
                <asp:Button runat="server" Text="Delete"
                    CssClass="btn delete"
                    CommandName="DeleteRFID"
                    CommandArgument='<%# Eval("TournamentMemberID") %>' />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>

<br />

<!-- ===== MEMBERS WITHOUT RFID ===== -->
<h3>Members without RFID</h3>

<asp:GridView ID="gvWithoutRFID" runat="server"
    AutoGenerateColumns="False"
    DataKeyNames="TournamentMemberID,TournamentID"
    OnRowCommand="gv_RowCommand">

    <Columns>
        <asp:BoundField DataField="TournamentMemberID" HeaderText="ID" />
        <asp:BoundField DataField="MemberName" HeaderText="Name" />

        <asp:TemplateField HeaderText="RFID">
            <ItemTemplate>
                <asp:TextBox ID="txtRFID" runat="server" />
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField>
            <ItemTemplate>
                <asp:Button runat="server" Text="Save"
                    CssClass="btn assign"
                    CommandName="SaveRFID"
                    CommandArgument='<%# Eval("TournamentMemberID") %>' />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>

<br />
<asp:Label ID="lblMsg" runat="server" ForeColor="Green" />

</asp:Content>
