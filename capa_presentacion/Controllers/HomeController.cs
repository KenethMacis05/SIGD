using capa_datos;
using capa_entidad;
using capa_negocio;
using capa_presentacion.Controllers;
using capa_presentacion.Filters;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace capa_presentacion.Controllers
{
    [VerificarSession]
    public class HomeController : Controller
    {
        CN_Dashboard CN_Dashboard = new CN_Dashboard();

        public ActionResult Index()
        {
            var usuario = (USUARIOS)Session["UsuarioAutenticado"];

            try
            {
                ViewBag.MatricesPendientes = CN_Dashboard.ContarMatricesAsignaturasPendientes(usuario.id_usuario);
                ViewBag.AlmacenamientoUsado = CN_Dashboard.ObtenerAlmacenamientoUsuario(usuario.id_usuario);
                ViewBag.ArchivosCompartidos = CN_Dashboard.ContarArchivosCompartidosPorMi(usuario.id_usuario);
                ViewBag.AvanceGlobal = CN_Dashboard.ObtenerAvanceGlobal(usuario.id_usuario);
                // Para el gráfico de progreso semanal
                var progresoSemanal = CN_Dashboard.ObtenerProgresoSemanal(usuario.id_usuario, 8);

                // Preparar datos para Chart.js
                ViewBag.SemanasLabels = JsonConvert.SerializeObject(progresoSemanal.Select(p => $"Semana {p.Semana}").ToArray());
                ViewBag.ContenidosFinalizados = JsonConvert.SerializeObject(progresoSemanal.Select(p => p.Finalizados).ToArray());
                ViewBag.ContenidosPendientes = JsonConvert.SerializeObject(progresoSemanal.Select(p => p.Pendientes).ToArray());

                // Datos para tabla o resumen
                ViewBag.ProgresoSemanal = progresoSemanal;
                ViewBag.TotalFinalizados = progresoSemanal.Sum(p => p.Finalizados);
                ViewBag.TotalPendientes = progresoSemanal.Sum(p => p.Pendientes);
                return View();
            }
            catch (Exception ex)
            {
                ViewBag.Error = "Error al cargar el dashboard: " + ex.Message;
                return View();
            }
        }
        
        public ActionResult Error()
        {
            return View();
        }

        public ActionResult CerrarSesion()
        {
            Session["UsuarioAutenticado"] = null;
            Session["RolUsuario"] = null;
            Session.Clear();
            Session.Abandon();
            return RedirectToAction("Index", "Acceso");
        }
    }
}