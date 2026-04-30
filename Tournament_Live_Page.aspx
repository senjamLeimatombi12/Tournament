<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Tournament_Live_Page.aspx.cs" Inherits="Marathone.Tournament_Live_Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Live Tournament Leaderboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { background: #f8f9fa; }
        .header { background: #0d6efd; color: white; padding: 15px; border-radius: 8px; }
        .summary-card { border-radius: 12px; box-shadow: 0 2px 6px rgba(0,0,0,0.1); }
        .leaderboard { margin-top: 20px; }
        .gold { background-color: #ffd70022; }
        .silver { background-color: #c0c0c022; }
        .bronze { background-color: #cd7f3222; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <form id="form1" runat="server" class="container py-4">

        <!-- HEADER -->
        <div class="header text-center mb-4">
            <h2>🏁 Live Tournament Leaderboard</h2>
        </div>

        <!-- TOURNAMENT DROPDOWN -->
        <div class="row mb-3">
            <div class="col-md-6">
                <asp:DropDownList ID="ddlTournaments" runat="server" CssClass="form-select" AutoPostBack="true"
                    OnSelectedIndexChanged="ddlTournaments_SelectedIndexChanged"></asp:DropDownList>
            </div>
            <div class="col-md-6 text-end">
                <asp:Label ID="lblTournamentInfo" runat="server" CssClass="fw-bold text-secondary"></asp:Label>
            </div>
        </div>

        <!-- SUMMARY SECTION -->
        <div class="row text-center mb-4">
            <div class="col-md-3">
                <div class="p-3 bg-light summary-card">
                    <h5>Total Athletes</h5>
                    <asp:Label ID="lblTotalAthletes" runat="server" CssClass="fs-4 fw-bold text-primary"></asp:Label>
                </div>
            </div>
            <div class="col-md-3">
                <div class="p-3 bg-light summary-card">
                    <h5>Started</h5>
                    <asp:Label ID="lblStarted" runat="server" CssClass="fs-4 fw-bold text-info"></asp:Label>
                </div>
            </div>
            <div class="col-md-3">
                <div class="p-3 bg-light summary-card">
                    <h5>Finished</h5>
                    <asp:Label ID="lblFinished" runat="server" CssClass="fs-4 fw-bold text-success"></asp:Label>
                </div>
            </div>
            <div class="col-md-3">
                <div class="p-3 bg-light summary-card">
                    <h5>Ongoing</h5>
                    <asp:Label ID="lblOngoing" runat="server" CssClass="fs-4 fw-bold text-warning"></asp:Label>
                </div>
            </div>
        </div>

        <!-- LEADERBOARD -->
        <div class="leaderboard">
            <asp:GridView ID="gvLeaderboard" runat="server" CssClass="table table-striped table-hover"
                AutoGenerateColumns="False" BorderStyle="None" OnRowDataBound="gvLeaderboard_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="Rank" HeaderText="Rank" />
                    <asp:BoundField DataField="Name" HeaderText="Athlete" />
                    <asp:BoundField DataField="Age" HeaderText="Age" />
                    <asp:BoundField DataField="Team" HeaderText="Team" />
                    <asp:BoundField DataField="StartTime" HeaderText="Start" DataFormatString="{0:HH:mm:ss}" />
                    <asp:BoundField DataField="FinishTime" HeaderText="Finish" DataFormatString="{0:HH:mm:ss}" />
                    <asp:BoundField DataField="TotalTime" HeaderText="Total Time" />
                    <asp:BoundField DataField="Status" HeaderText="Status" />
                </Columns>
            </asp:GridView>
        </div>

        <!-- AUTO REFRESH TIMER -->
        <asp:Timer ID="Timer1" runat="server" Interval="5000" OnTick="Timer1_Tick" />
    </form>
</asp:Content>

