<%@ Page Title="Post Notice - Admin" Language="C#" MasterPageFile="~/Site1.Master" 
         AutoEventWireup="true" CodeBehind="Notice_News_Update.aspx.cs" 
         Inherits="Marathone.Notice_News_Update" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --primary: #0d6efd;
            --primary-dark: #0b5ed7;
            --gray-50: #f9f9fd;
            --gray-100: #f1f3f9;
            --gray-300: #d0d5dd;
            --gray-700: #344767;
            --gray-900: #1a1f2e;
            --success: #0d8744;
            --radius: 16px;
            --shadow-sm: 0 4px 20px rgba(13,110,253,0.08);
            --shadow-lg: 0 20px 50px rgba(13,110,253,0.18);
        }

        body {
            background: linear-gradient(140deg, #f8f9ff 0%, #eef1ff 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            color: var(--gray-900);
        }

        .container {
            max-width: 620px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .notice-card {
            background: #ffffff;
            border-radius: var(--radius);
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            border: 1px solid rgba(13,110,253,0.12);
            transition: all 0.35s ease;
        }

        .notice-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-lg);
        }

        .card-header {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            padding: 36px 40px;
            text-align: center;
            color: white;
        }

        .card-header h1 {
            margin: 0;
            font-size: 1.9rem;
            font-weight: 700;
            letter-spacing: -0.6px;
        }

        .card-header p {
            margin: 12px 0 0;
            font-size: 1rem;
            opacity: 0.94;
        }

        .card-body {
            padding: 44px 40px;
        }

        .form-group {
            margin-bottom: 28px;
        }

        .form-label {
            display: block;
            font-weight: 600;
            color: var(--gray-700);
            margin-bottom: 10px;
            font-size: 0.98rem;
        }

        .form-control {
            width: 100%;
            padding: 15px 18px;
            border: 2px solid var(--gray-300);
            border-radius: 12px;
            font-size: 1.02rem;
            background: #fafbff;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            background: #ffffff;
            box-shadow: 0 0 0 5px rgba(13,110,253,0.16);
        }

        textarea.form-control {
            min-height: 150px;
            resize: vertical;
            font-family: inherit;
        }

        .btn-publish {
            width: 100%;
            padding: 17px;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            border: none;
            border-radius: 14px;
            font-size: 1.15rem;
            font-weight: 600;
            letter-spacing: 0.6px;
            cursor: pointer;
            transition: 0.4s ease;
            text-transform: uppercase;
        }

        .btn-publish:hover {
            transform: translateY(-4px);
            box-shadow: 0 14px 35px rgba(13,110,253,0.4);
        }

        .message {
            margin-top: 24px;
            padding: 16px 20px;
            border-radius: 12px;
            text-align: center;
            font-weight: 600;
            font-size: 1rem;
        }

        .message.success {
            background: #d1e7dd;
            color: var(--success);
            border: 1px solid #badbcc;
        }

        .message.error {
            background: #f8d7da;
            color: #842029;
            border: 1px solid #f5c2c7;
        }

        @media (max-width: 576px) {
            .container { padding: 0 16px; margin: 20px auto; }
            .card-header { padding: 28px 24px; }
            .card-header h1 { font-size: 1.7rem; }
            .card-body { padding: 36px 24px; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container">
        <div class="notice-card">

            <!-- Premium Header -->
            <div class="card-header">
                <h1>Post New Notice</h1>
                <p>Share important updates with all participants</p>
            </div>

            <!-- Form -->
            <div class="card-body">

                <div class="form-group">
                    <label class="form-label">Notice Title</label>
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control"
                                 placeholder="e.g., Start Time Changed to 7:00 AM" />
                </div>

                <div class="form-group">
                    <label class="form-label">Full Description</label>
                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="7"
                                 CssClass="form-control"
                                 placeholder="Provide all necessary details..." />
                </div>

                <asp:Button ID="btnSave" runat="server" Text="Publish Notice"
                            CssClass="btn-publish" OnClick="btnSave_Click" />

                <!-- Message Display -->
                <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>

            </div>
        </div>
    </div>

    <!-- Optional: Style message in code-behind -->
    <script runat="server">
        // Example usage in btnSave_Click:
        // lblMessage.Text = "Notice published successfully!";
        // lblMessage.CssClass = "message success";
        // lblMessage.Visible = true;
    </script>
</asp:Content>