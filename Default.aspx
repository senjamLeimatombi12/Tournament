<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Marathone.Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>UHF RFID Live Reader - Real Time Dashboard</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        h1 {
            color: #007acc;
            text-align: center;
        }
    </style>
</head>
<body>

<form id="form1" runat="server">

    <!-- ScriptManager MUST be at the top -->
    <asp:ScriptManager ID="ScriptManager1" runat="server" />

    <div class="container">

        <h1>UHF RFID Reader - Live Tags</h1>

        <div class="controls">
            <asp:Button ID="btnStart" runat="server" Text="Start Reading" CssClass="btn start" OnClick="btnStart_Click" />
            <asp:Button ID="btnStop" runat="server" Text="Stop Reading" CssClass="btn stop" OnClick="btnStop_Click" />
        </div>

        <div class="status">
            Status: <asp:Label ID="lblStatus" runat="server" Text="Stopped" ForeColor="Red" />
        </div>

        <div class="total">
            Total Unique Tags Detected:
            <asp:Label ID="lblTotal" runat="server" Text="0" />
        </div>

        <!-- Only ONE GridView -->
        <asp:UpdatePanel ID="upd1" runat="server" UpdateMode="Conditional">
            <ContentTemplate>

                <asp:GridView ID="gvTags" runat="server" AutoGenerateColumns="false">
                    <Columns>
                        <asp:BoundField DataField="EPC" HeaderText="EPC (Hex)" />
                        <asp:BoundField DataField="UserName" HeaderText="Name" />
                        <asp:BoundField DataField="Age" HeaderText="Age" />
                        <asp:BoundField DataField="Antenna" HeaderText="Antenna" />
                        <asp:BoundField DataField="RSSI" HeaderText="RSSI" />
                        <asp:BoundField DataField="Count" HeaderText="Count" />
                        <asp:BoundField DataField="FirstSeen" HeaderText="First Seen" DataFormatString="{0:HH:mm:ss}" />
                        <asp:BoundField DataField="LastSeen" HeaderText="Last Seen" DataFormatString="{0:HH:mm:ss}" />
                    </Columns>
                </asp:GridView>

            </ContentTemplate>

            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="Timer1" EventName="Tick" />
            </Triggers>
        </asp:UpdatePanel>

        <asp:Timer ID="Timer1" runat="server" Interval="1000" OnTick="Timer1_Tick" />

    </div>

</form>
</body>
</html>