using capa_presentacion.Filters;
using capa_presentacion.Controllers;
using capa_negocio;
using capa_datos;
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
        public ActionResult Index()
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