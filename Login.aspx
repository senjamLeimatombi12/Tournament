<%@ Page Title="Login - Marathone" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Marathone.Login" %>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <style>
        .role-pill {
    cursor: pointer;
}
        .login-radio + .login-radio { margin-left: 8px; }

.role-pill input {
    display: none;
}

.role-pill span {
    display: inline-block;
    padding: 8px 18px;
    border-radius: 999px;
    border: 1.5px solid #d1d5db;
    font-weight: 600;
    color: #333;
    transition: all 0.25s ease;
}

.role-pill input:checked + span {
    background: #0d6efd;
    color: #fff;
    border-color: #0d6efd;
}


        body {
            background: #f8f9fd;
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .login-wrapper {
            min-height: 100vh;
            display: flex;
            align-items: flex-start;
            justify-content: center;
            padding-top: 10vh;
        }

        .login-card {
            background: #fff;
            width: 100%;
            max-width: 380px;
            padding: 36px 32px;
            border-radius: 14px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.09);
            border: 1px solid #eaeef5;
        }

        .login-header {
            text-align: center;
            margin-bottom: 26px;
        }

        .login-header p {
            margin: 0;
            font-size: 1.18rem;
            font-weight: 750;
            color: #1877f2;
        }

        .form-label {
            font-size: 0.9rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 7px;
        }

        .form-control {
            height: 48px;
            border: 1.5px solid #d1d5db;
            border-radius: 10px;
            padding: 0 14px;
            font-size: 1rem;
        }

        .btn-login {
            height: 48px;
            background: #0d6efd;
            border-radius: 10px;
            font-weight: 600;
            margin-top: 8px;
        }

        .extra-links {
            text-align: center;
            margin-top: 20px;
            font-size: 0.89rem;
        }

      
   
    </style>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<body class="no-sidebar">
    <div class="login-wrapper">
        <div class="login-card">

            <div class="login-header">
                <p>Sign in to your account</p>
            </div>

            <div class="mb-3">
                <label class="form-label">Email Address</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"
                    TextMode="Email" placeholder="you@example.com" />
            </div>

            <div class="mb-3">
                <label class="form-label">Password</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control"
                    TextMode="Password" placeholder="Enter your password" />
            </div>

          <div class="mb-3 login-as-row">
    <label class="form-label me-2">Login As:</label>
<asp:RadioButton ID="rbUser" runat="server" GroupName="LoginType"
    Text="User" Checked="True" CssClass="login-radio" />
<asp:RadioButton ID="rbAdmin" runat="server" GroupName="LoginType"
    Text="Admin" CssClass="login-radio" /></div>

   




            <asp:Button ID="btnLogin" runat="server" Text="Sign In"
                CssClass="btn btn-primary btn-login w-100 text-white"
                OnClick="btnLogin_Click" />

            <div class="extra-links">
                <div>
                    <asp:HyperLink NavigateUrl="~/ForgotPassword.aspx"
                        Text="Forgot password?" runat="server" />
                </div>
                <div class="mt-2">
                    New here?
                    <asp:HyperLink NavigateUrl="~/Register.aspx"
                        Text="Create an account" runat="server" />
                </div>
            </div>

        </div>
    </div>
</body>
</asp:Content>
