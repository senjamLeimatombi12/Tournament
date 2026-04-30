<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="ApplicationDetailReview.aspx.cs"
    Inherits="Marathone.ApplicationDetailReview" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Application Review</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            background: #ffffff; /* Changed to white */
            font-family: 'Segoe UI', Arial, sans-serif;
            color: #1f2937;
        }
        /* Big card - now soft royal blue */
        .outer-box {
            max-width: 1200px;
            margin: 50px auto;
            padding: 40px;
            background: #EAF2FF; /* Soft pale sky blue */
            border-radius: 18px;
            box-shadow: 0 12px 35px rgba(59,130,246,.18);
        }
        .page-title {
            text-align: center;
            font-size: 30px;
            font-weight: 600;
            color: #2563eb;

            margin-bottom: 40px;
        }
        /* Small white topic box - slightly narrower */
        .topic-box {
            background: #ffffff;
            border-radius: 14px;
            padding: 28px 30px;
            margin-bottom: 28px;
            margin-left: auto;
            margin-right: auto;
            max-width: 92%; /* Slightly lesser in width than before */
            box-shadow: 0 6px 18px rgba(0,0,0,.08);
        }
        .topic-title {
            font-size: 18px;
            font-weight: 600;
            color: #2563eb;
            margin-bottom: 20px;
            border-bottom: 1px solid #e5e7eb;
            padding-bottom: 8px;
        }
        /* Two-column detail rows */
        .detail-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 14px;
        }
        .detail-item label {
            font-size: 13px;
            font-weight: 600;
            color: #6b7280;
            margin-bottom: 4px;
            display: block;
        }
        .detail-item div {
            font-size: 16px;
            font-weight: 500;
        }
        /* Full width (for address) */
        .full-row {
            grid-template-columns: 1fr !important;
        }
        /* Buttons */
        .action-bar {
            text-align: center;
            margin-top: 40px;
        }
        .btn-primary {
            background:#1F4BB8;
            border: none;
            padding: 12px 40px;
            font-weight: 600;
            border-radius: 8px;
        }
        .btn-secondary {
            background: #ffffff;
            border: 1px solid #2563eb;
            color: #2563eb;
            padding: 12px 40px;
            font-weight: 600;
            border-radius: 8px;
        }
        .btn-disabled {
            background: #cbd5e1 !important;
            color: #64748b !important;
            cursor: not-allowed;
        }
        @media(max-width:768px) {
            .detail-row {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<form runat="server">
<div class="outer-box">
    <div class="page-title">Application Review</div>
    <asp:Panel ID="pnlDetails" runat="server">
        <!-- C# will inject topic-box blocks here -->
    </asp:Panel>
    <div class="action-bar">
        <asp:Button ID="btnBack" runat="server"
            CssClass="btn btn-secondary me-3"
            Text="Back"
            OnClick="btnBack_Click" />
        <asp:Button ID="btnFinalSubmit" runat="server"
            CssClass="btn btn-primary"
            Text="Final Submit"
            OnClick="btnFinalSubmit_Click" />
    </div>
</div>
</form>
</body>
</html>