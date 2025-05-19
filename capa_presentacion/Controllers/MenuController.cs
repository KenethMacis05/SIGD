using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using capa_presentacion.Filters;
using capa_negocio;
using capa_entidad;

namespace capa_presentacion.Controllers
{
    [VerificarSession]
    public class MenuController : Controller
    {
        // GET: Menu
        public ActionResult Index()
        {
            return View();
        }

        CN_Menu CN_Menu = new CN_Menu();

        // Metodo para listar los menus de un rol
        [AllowAnonymous]
        [HttpGet]
        public JsonResult ListarMenusPorRol(int IdRol)
        {
            List<MENU> lst = new List<MENU>();
            lst = CN_Menu.ListarMenusPorRol(IdRol);

            return Json(new { data = lst }, JsonRequestBehavior.AllowGet);
        }

        // Metodo para borrar menus
        [HttpPost]
        public JsonResult EliminarMenu(int id_menu)
        {
            string mensaje = string.Empty;
            int resultado = CN_Menu.Eliminar(id_menu, out mensaje);
            return Json(new { Respuesta = (resultado == 1), Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }
    }
}