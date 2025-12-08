<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReporteViewer.aspx.cs" Inherits="capa_presentacion.Reportes.ReporteViewer" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=15.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <link href="<%= Page.ResolveUrl("~/Content/Views/Reporte.css") %>" rel="stylesheet" type="text/css" />
    <title>Reporte</title>
</head>
<body>
    <div class="corporate-header">
        <div class="header-inner">
            <div class="logo-section">
                <div class="report-info">
                    <h1>Sistema de Reportes</h1>
                </div>
            </div>
            <div class="corporate-actions">
                <%--<button class="corp-btn" onclick="window.print()">🖨️ Imprimir</button>--%>
                <button class="corp-btn" onclick="window.history.back()">← Volver</button>
            </div>
        </div>
    </div>

    <div class="main-content">
        <div class="report-frame">
            <form id="form1" runat="server">
                <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
                <rsweb:ReportViewer
                    ID="RVReporte"
                    runat="server"
                    Width="100%"
                    Height="800px"
                    ProcessingMode="Remote"
                    SizeToReportContent="True"
                    ShowParameterPrompts="False"
                    ShowWaitControlCancelLink="False"
                    ExportContentDisposition="AlwaysAttachment">
                </rsweb:ReportViewer>
            </form>
        </div>
    </div>
</body>
</html>
