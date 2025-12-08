using capa_entidad;
using capa_negocio;
using capa_presentacion.Filters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace capa_presentacion.Controllers
{
    [VerificarSession]
    public class ReporteController : Controller
    {
        CN_Reporte CN_Reporte = new CN_Reporte();

        // GET: Reporte
        public ActionResult Index()
        {
            return View();
        }

        [AllowAnonymous]
        [HttpGet]
        public JsonResult GetReporte()
        {
            var usuario = (USUARIOS)Session["UsuarioAutenticado"];
            if (usuario == null) return Json(new { success = false, message = "Sesión expirada" }, JsonRequestBehavior.AllowGet);

            List<REPORTE> lst = new List<REPORTE>();
            lst = CN_Reporte.ListarPorDominios(usuario.id_usuario);

            return Json(new { data = lst }, JsonRequestBehavior.AllowGet);
        }
    }
}