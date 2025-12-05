using capa_entidad;
using Microsoft.Reporting.WebForms;
using Microsoft.ReportingServices.ReportProcessing.ReportObjectModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.ScriptManager;

namespace capa_presentacion.ReportesRDLC
{
    public partial class ReporteRDLCViewer : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            ConfigurarReporte();
        }

        private void ConfigurarReporte()
        {
            string rutaReporteTest1 = "~/ReportesRDLC/Matriz.rdlc";

            ReportViewer1.ProcessingMode = ProcessingMode.Local;
            ReportViewer1.LocalReport.ReportPath = Server.MapPath(rutaReporteTest1);

            // Configurar parámetros
            var parametros = new List<Microsoft.Reporting.WebForms.ReportParameter>();
            
            ReportViewer1.LocalReport.Refresh();
        }
    }
}