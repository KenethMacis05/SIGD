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
        private readonly CN_Menu objMenu = new CN_Menu();
         
        // GET: Menu
        public ActionResult Index()
        {
            return View();
        }

        // Enpoint(GET): Listar menus por rol de usuario
        [AllowAnonymous]
        [HttpGet]
        public JsonResult ListarMenusPorRol(int IdRol)
        {
            List<MENU> lst = new List<MENU>();
            lst = objMenu.ListarMenusPorRol(IdRol);

            return Json(new { data = lst }, JsonRequestBehavior.AllowGet);
        }

        // Enpoint(GET): Listar menus no asignados del rol de usuario                
        [AllowAnonymous]
        [HttpGet]
        public JsonResult ListarMenusNoAsignadosPorRol(int IdRol)
        {
            List<MENU> lst = new List<MENU>();
            lst = objMenu.ListarMenusNoAsignadosPorRol(IdRol);

            return Json(new { data = lst }, JsonRequestBehavior.AllowGet);
        }

        // Enpoint(POST): Asignar menus a un rol de usuario
        [HttpPost]
        public JsonResult AsignarMenus(int IdRol, List<int> IdsMenus)
        {
            try
            {                
                var resultados = objMenu.AsignarMenus(IdRol, IdsMenus);

                var data = resultados.Select(r => new {
                    IdControlador = r.Key,
                    Codigo = r.Value.Codigo,
                    Mensaje = r.Value.Mensaje,
                    EsExitoso = r.Value.Codigo > 0
                }).ToList();

                return Json(new
                {
                    success = true,
                    data = data,
                    totalExitosos = data.Count(d => d.EsExitoso),
                    totalFallidos = data.Count(d => !d.EsExitoso)
                });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        // Enpoint(POST): Eliminar menú del rol de usuario
        [HttpPost]
        public JsonResult EliminarMenuDelRol(int IdMenuRol)
        {
            string mensaje = string.Empty;
            int resultado = objMenu.EliminarMenuDelRol(IdMenuRol, out mensaje);
            return Json(new { Respuesta = (resultado == 1), Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }
    }
}