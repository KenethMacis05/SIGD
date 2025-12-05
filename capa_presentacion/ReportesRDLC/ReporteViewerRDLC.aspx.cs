// ReportesRDLC/ReporteViewerRDLC.aspx.cs
using capa_presentacion.ReportesRDLC.Generadores;
using capa_entidad;
using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Web.UI;

namespace capa_presentacion.ReportesRDLC
{
    public partial class ReporteViewerRDLC : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var usuario = (USUARIOS)Session["UsuarioAutenticado"];

            if (usuario == null)
            {
                Response.Redirect("/Home/index");
                return;
            }

            if (!IsPostBack)
            {
                ConfigurarReporte();
            }
        }

        private void ConfigurarReporte()
        {
            try
            {
                string nombreReporte = Request.QueryString["Reporte"];
                string id = Request.QueryString["id"];

                if (string.IsNullOrEmpty(nombreReporte))
                {
                    MostrarError("No se especificó el reporte");
                    return;
                }

                // Factory pattern para crear el generador correcto
                IReporteGenerador generador = CrearGenerador(nombreReporte, id);

                if (generador == null)
                {
                    MostrarError($"Reporte '{nombreReporte}' no configurado");
                    return;
                }

                // Configurar reporte base
                ReporteHelper.ConfigurarReporteBase(ReportViewer1, generador.NombreReporte, generador.ObtenerParametros());

                // Configurar data sources
                var dataSources = generador.ObtenerDataSources();
                ReportViewer1.LocalReport.DataSources.Clear();

                foreach (var ds in dataSources)
                {
                    ReportViewer1.LocalReport.DataSources.Add(ds);
                }

                ReportViewer1.LocalReport.Refresh();
            }
            catch (Exception ex)
            {
                MostrarError($"Error: {ex.Message}");
            }
        }

        private IReporteGenerador CrearGenerador(string nombreReporte, string id)
        {
            switch (nombreReporte)
            {
                case "MatrizIntegracionComponente":
                    return new MatrizIntegracionGenerador(id);

                default:
                    return null;
            }
        }

        private void MostrarError(string mensaje)
        {
            Response.Write($"<script>alert('{mensaje}'); window.history.back();</script>");
        }
    }
}