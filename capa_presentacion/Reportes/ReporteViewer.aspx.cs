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
                string nombreReporte = Request.QueryString["Reporte"];

                if (string.IsNullOrEmpty(nombreReporte))
                {
                    MostrarError("No se especificó el reporte");
                    return;
                }

                // Obtener la ruta completa del reporte
                string rutaReporte = ObtenerRutaReporte(nombreReporte);

                if (string.IsNullOrEmpty(rutaReporte))
                {
                    MostrarError($"Reporte '{nombreReporte}' no encontrado");
                    return;
                }

                // Configurar servidor de reportes
                RVReporte.ServerReport.ReportServerUrl = new Uri(ReportServerUrl);
                RVReporte.ServerReport.ReportPath = rutaReporte;

                // Configurar parámetros
                EstablecerParametros(nombreReporte);

                RVReporte.ServerReport.Refresh();
            }
            catch (Exception ex)
            {
                MostrarError($"Error al cargar el reporte: {ex.Message}");
            }
        }

        private string ObtenerRutaReporte(string nombreReporte)
        {
            var rutasReportes = new Dictionary<string, string>
            {
                { "MatrizIntegracionComponente", "/MatrizIntegracionComponente/MatrizIntegracionComponente" },
                { "PlanDidacticoSemestral", "/PlanDidacticoSemestral/PlanDidacticoSemestral" },
                { "PlanClasesDiario", "/PlanClasesDiario/PlanClasesDiario" },
                { "MIC-5 - Resumen de Matrices por Área/Departamento/Carrera", "/MatrizIntegracionComponente/ReporteResumenMatrizXAreaXDepartamentoXCarrera" }
            };

            return rutasReportes.ContainsKey(nombreReporte)
                ? rutasReportes[nombreReporte]
                : null;
        }

        private void EstablecerParametros(string nombreReporte)
        {
            List<ReportParameter> reportParameters = new List<ReportParameter>();

            switch (nombreReporte)
            {
                case "MatrizIntegracionComponente":
                    reportParameters.Add(new ReportParameter("IdMatrizIntegracionInforme", Request.QueryString["id"]));
                    break;
                case "PlanDidacticoSemestral":
                    reportParameters.Add(new ReportParameter("IdPlaSemestral", Request.QueryString["id"]));
                    break;
                case "PlanClasesDiario":
                    reportParameters.Add(new ReportParameter("IdPlaClasesDiario", Request.QueryString["id"]));
                    break;
                case "MIC-5 - Resumen de Matrices por Área/Departamento/Carrera":
                    reportParameters.Add(new ReportParameter("IdArea", NullSafeValue(Request.QueryString["area"])));
                    reportParameters.Add(new ReportParameter("IdDepartamento", NullSafeValue(Request.QueryString["departamento"])));
                    reportParameters.Add(new ReportParameter("IdCarrera", NullSafeValue(Request.QueryString["carrera"])));
                    reportParameters.Add(new ReportParameter("Codigo", NullSafeValue(Request.QueryString["codigo"])));
                    reportParameters.Add(new ReportParameter("Periodo", NullSafeValue(Request.QueryString["periodo"])));
                    reportParameters.Add(new ReportParameter("IdMatrizIntegracion", NullSafeValue(null)));
                    break;
                default:
                    break;
            }

            if (reportParameters.Count > 0)
            {
                this.RVReporte.ServerReport.SetParameters(reportParameters);
            }
        }

        private void MostrarError(string mensaje)
        {
            Response.Write($"<script>alert('{mensaje}'); window.history.back();</script>");
        }

        private string NullSafeValue(string value)
        {
            return (value == "NULL" || string.IsNullOrEmpty(value)) ? null : value;
        }

    }
}