// ReportesRDLC/ReporteHelper.cs
using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;

namespace capa_presentacion.ReportesRDLC
{
    public class ReporteHelper
    {
        public static void ConfigurarReporteBase(ReportViewer reportViewer, string nombreReporte, Dictionary<string, object> parametros = null)
        {
            string rutaReporte = $"/ReportesRDLC/{nombreReporte}.rdlc";
            reportViewer.LocalReport.ReportPath = HttpContext.Current.Server.MapPath(rutaReporte);

            // Configurar parámetros si existen
            if (parametros != null && parametros.Count > 0)
            {
                List<ReportParameter> reportParams = new List<ReportParameter>();
                foreach (var param in parametros)
                {
                    reportParams.Add(new ReportParameter(param.Key, param.Value?.ToString() ?? ""));
                }
                reportViewer.LocalReport.SetParameters(reportParams);
            }

            reportViewer.LocalReport.Refresh();
        }

        public static ReportDataSource CrearDataSource(string nombreDataSet, DataTable data)
        {
            data.TableName = nombreDataSet;
            return new ReportDataSource(nombreDataSet, data);
        }
    }
}