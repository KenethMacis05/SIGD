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

namespace capa_presentacion.Reportes
{
    public partial class ReporteViewer : System.Web.UI.Page
    {
        private readonly string ReportServerUrl = WebConfigurationManager.AppSettings["ReportServerUrl"];

        protected void Page_Load(object sender, EventArgs e)
        {
            var usuario = (USUARIOS)Session["UsuarioAutenticado"];

            if (usuario != null)
            {
                if (!IsPostBack)
                {
                    ConfigurarReporte();
                }
            }
            else
            {
                Response.Redirect("/Home/index");
            }
        }

        private void ConfigurarReporte()
        {
            try
            {
                string reporte = Request.QueryString["Reporte"];

                if (string.IsNullOrEmpty(reporte))
                {
                    MostrarError("No se especificó el reporte");
                    return;
                }

                // Configurar servidor de reportes
                RVReporte.ServerReport.ReportServerUrl = new Uri(ReportServerUrl);
                RVReporte.ServerReport.ReportPath = reporte;

                // Configurar parámetros
                EstablecerParametros();

                RVReporte.ServerReport.Refresh();
            }
            catch (Exception ex)
            {
                MostrarError($"Error al cargar el reporte: {ex.Message}");
            }
        }

        private void EstablecerParametros()
        {
            List<ReportParameter> reportParameters = new List<ReportParameter>();

            switch (Request.QueryString["Reporte"])
            {
                case "/MatrizIntegracionComponente/MatrizIntegracionComponente":
                    reportParameters.Add(new ReportParameter("IdMatrizIntegracionInforme", Request.QueryString["id"]));
                    break;
                case "/PlanDidacticoSemestral/PlanDidacticoSemestral":
                    reportParameters.Add(new ReportParameter("IdPlaSemestral", Request.QueryString["id"]));
                    break;
                case "/PlanClasesDiario/PlanClasesDiario":
                    reportParameters.Add(new ReportParameter("IdPlaClasesDiario", Request.QueryString["id"]));
                    break;
                default:
                    break;
            }

            this.RVReporte.ServerReport.SetParameters(reportParameters);
        }

        private void MostrarError(string mensaje)
        {
            Response.Write($"<script>alert('{mensaje}'); window.history.back();</script>");
        }
    }
}