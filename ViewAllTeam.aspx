<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="ViewAllTeam.aspx.cs" Inherits="Marathone.ViewAllTeam" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .table th {
        text-align: center !important;
        vertical-align: middle !important;
    }
        
    .assign-professional {
        background-color:#77C7F3 !important;
        color: black !important;
        border: none !important;
        padding: 6px 12px;
        border-radius: 6px;
        cursor: pointer;
    }
</style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<h2>All Teams</h2>

<asp:GridView ID="gvTeams" runat="server" AutoGenerateColumns="false" 
    CssClass="table table-bordered" EmptyDataText="No teams found"
    OnRowCommand="gvTeams_RowCommand">

    <Columns>
        <asp:BoundField DataField="TeamID" Visible="false" />
        <asp:BoundField DataField="TeamName" HeaderText="Team Name" ItemStyle-Width="120px" 
               />

        <asp:BoundField DataField="CreatedDate" HeaderText="Created Date" ItemStyle-Width="130px" ItemStyle-HorizontalAlign="Center"
            HeaderStyle-HorizontalAlign="Center"  />

        <asp:TemplateField HeaderText="Action">
            <HeaderStyle HorizontalAlign="Center" Width="160px" />
            <ItemStyle HorizontalAlign="Center" Width="160px" />
    <ItemTemplate>
        <asp:Button ID="btnView" runat="server"
            Text="View Members" CssClass="assign-professional"
            CommandName="ViewMembers"
            CommandArgument='<%# Eval("TeamID") %>' />
    </ItemTemplate>
            </asp:TemplateField>
        <asp:TemplateField HeaderText="Delete">
            <HeaderStyle HorizontalAlign="Center" Width="120px" />
            <ItemStyle HorizontalAlign="Center" Width="120px" />
    <ItemTemplate>
        <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="assign-professional" CommandName="DeleteTeam"
           
            CommandArgument='<%# Eval("TeamID") %>'
            OnClientClick="return confirm('Are you sure you want to delete this item?');" />
    </ItemTemplate>
</asp:TemplateField>
         </Columns>
</asp:GridView>

<h3>Team Members</h3>

<asp:GridView ID="gvMembers" runat="server" AutoGenerateColumns="false"
    CssClass="table table-bordered">

    <Columns>
    <asp:BoundField DataField="MemberID" HeaderText="Member ID" >
        <HeaderStyle Width="120px" HorizontalAlign="Center" />
        <ItemStyle Width="120px" HorizontalAlign="Center" />
    </asp:BoundField>

    <asp:BoundField DataField="Name" HeaderText="Name">
        <HeaderStyle Width="120px" HorizontalAlign="Center" />
        <ItemStyle Width="120px" HorizontalAlign="Center" />
    </asp:BoundField>

    <asp:BoundField DataField="Age" HeaderText="Age">
        <HeaderStyle Width="100px" HorizontalAlign="Center" />
        <ItemStyle Width="100px" HorizontalAlign="Center" />
    </asp:BoundField>

    <asp:BoundField DataField="RFID" HeaderText="RFID">
        <HeaderStyle Width="160px" HorizontalAlign="Center" />
        <ItemStyle Width="160px" HorizontalAlign="Center" />
    </asp:BoundField>
</Columns>

</asp:GridView>

</asp:Content>
