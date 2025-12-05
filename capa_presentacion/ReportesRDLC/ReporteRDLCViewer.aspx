<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReporteRDLCViewer.aspx.cs" Inherits="capa_presentacion.ReportesRDLC.ReporteRDLCViewer" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>
<rsweb:ReportViewer ID="ReportViewer1" runat="server"></rsweb:ReportViewer>
