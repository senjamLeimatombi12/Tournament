<%@ Page Title="Forgot Password" Language="C#"
    MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="ForgotPassword.aspx.cs"
    Inherits="Marathone.ForgotPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Forgot Password</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:Label ID="lblLoginAs" runat="server" Text="Login As:" />
    <br />

    <asp:RadioButton ID="rbUser" runat="server"
        GroupName="LoginType" Text="User" Checked="True" />

    <asp:RadioButton ID="rbAdmin" runat="server"
        GroupName="LoginType" Text="Admin" />

    <br /><br />

    <asp:TextBox ID="txtMobile" runat="server"
        Placeholder="Registered Mobile Number" />

    <br /><br />

    <asp:Button ID="btnSendOTP" runat="server"
        Text="Send OTP"
        OnClick="btnSendOTP_Click" />

    <br /><br />

    <asp:Panel ID="pnlReset" runat="server" Visible="false">

        <asp:TextBox ID="txtOTP" runat="server"
            Placeholder="Enter OTP" />

        <br /><br />

        <asp:TextBox ID="txtNewPassword" runat="server"
            TextMode="Password"
            Placeholder="New Password" />

        <br /><br />

        <asp:Button ID="btnResetPassword" runat="server"
            Text="Reset Password"
            OnClick="btnResetPassword_Click" />

    </asp:Panel>

</asp:Content>
