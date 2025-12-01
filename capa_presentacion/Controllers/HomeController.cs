using capa_datos;
using capa_entidad;
using capa_negocio;
using capa_presentacion.Controllers;
using capa_presentacion.Filters;
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