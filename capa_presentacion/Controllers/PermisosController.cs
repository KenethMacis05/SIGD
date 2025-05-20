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
    public class PermisosController : Controller
    {
        private readonly CN_Permisos objPermisos = new CN_Permisos();

        // GET: Permisos
        public ActionResult Index()
        {
            return View();
        }

        // Enpoint(GET): Listar permisos por rol de usuario
        [HttpGet]
        public JsonResult ObtenerPermisosPorRol(int IdRol)
        {
            List<PERMISOS> lst = new List<PERMISOS>();
            lst = objPermisos.ListarPermisosPorRol(IdRol);

            return Json(new { data = lst }, JsonRequestBehavior.AllowGet);
        }

        // Enpoint(GET): Listar permisos no asignados por rol de usuario
        [HttpGet]
        public JsonResult ObtenerPermisosNoAsignados(int IdRol)
        {
            List<CONTROLLER> lst = new List<CONTROLLER>();
            lst = objPermisos.ListarPermisosNoAsignados(IdRol);

            return Json(new { data = lst }, JsonRequestBehavior.AllowGet);
        }

        // Enpoint(POST): Asignar permisos a un rol de usuario
        [HttpPost]
        public JsonResult AsignarPermisos(int IdRol, List<int> IdsControladores)
        {
            try
            {                
                var resultados = objPermisos.AsignarPermisos(IdRol, IdsControladores);

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

        // Enpoint(POST): Eliminar permisos de un rol de usuario
        [HttpPost]
        public JsonResult EliminarPermiso(int id_permiso)
        {
            string mensaje = string.Empty;
            int resultado = objPermisos.Eliminar(id_permiso, out mensaje);
            return Json(new { Respuesta = (resultado == 1), Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }
    }
}