using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Mvc;

namespace capa_presentacion.Controllers
{
    public class ReporteController : Controller
    {
        private readonly string ReportServerUrl = WebConfigurationManager.AppSettings["ReportServerUrl"];

        private readonly Dictionary<string, string> reportePaths = new Dictionary<string, string>
        {
            { "MatrizIntegracionComponente", "MatrizIntegracionComponente/MatrizIntegracionComponente" },
            { "PlanDidacticoSemestral", "PlanDidacticoSemestral/PlanDidacticoSemestral" },
            { "PlanClasesDiario", "PlanClasesDiario/PlanClasesDiario" }
        };

        public ActionResult VerReporte(string reporte, Dictionary<string, string> parametros)
        {
            try
            {
                // Validar que el reporte exista
                if (string.IsNullOrEmpty(reporte))
                {
                    TempData["Error"] = "Nombre del reporte no especificado";
                    return RedirectToAction("Index", "Home");
                }

                if (!reportePaths.ContainsKey(reporte))
                {
                    TempData["Error"] = "Reporte no encontrado";
                    return RedirectToAction("Index", "Home");
                }

                // Validar que haya parámetros (puedes ajustar según tus necesidades)
                if (parametros == null || !parametros.Any())
                {
                    TempData["Error"] = "No se especificaron parámetros para el reporte";
                    return RedirectToAction("Index", "Home");
                }

                // Construir la URL base del reporte
                string urlReporte = $"{ReportServerUrl}?/{reportePaths[reporte]}";

                // Agregar todos los parámetros
                foreach (var param in parametros)
                {
                    if (!string.IsNullOrEmpty(param.Value))
                    {
                        urlReporte += $"&{param.Key}={param.Value}";
                    }
                }

                return Redirect(urlReporte);
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Error al generar el reporte: {ex.Message}";
                return RedirectToAction("Index", "Home");
            }
        }

        // Reporte con parámetro único
        public ActionResult MatrizIntegracionComponente(string id)
        {
            var parametros = new Dictionary<string, string>
            {
                { "IdMatrizIntegracionInforme", id }
            };
            return VerReporte("MatrizIntegracionComponente", parametros);
        }

        // Reporte con parámetro único
        public ActionResult PlanDidacticoSemestral(string id)
        {
            var parametros = new Dictionary<string, string>
            {
                { "IdPlaSemestral", id }
            };
            return VerReporte("PlanDidacticoSemestral", parametros);
        }

        // Reporte con múltiples parámetros (como querías)
        public ActionResult PlanClasesDiario(string id)
        {
            var parametros = new Dictionary<string, string>
            {
                { "IdPlaClasesDiario", id },
            };
            return VerReporte("PlanClasesDiario", parametros);
        }
    }
}