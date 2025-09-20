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
    public class PlanificacionController : Controller
    {
        CN_PlanClasesDiario CN_PlanClasesDiario = new CN_PlanClasesDiario();

        public ActionResult Matriz_de_Integracion()
        {
            return View();
        }
        public ActionResult Plan_Didactico_Semestral()
        {
            return View();
        }

        #region PLAN DE CLASES DIARIO

        // Vista Plan de Clases Diario
        public ActionResult Plan_de_Clases_Diario()
        {
            return View();
        }

        // Enpoint(GET): Listar planes de clases del usuario
        [HttpGet]
        public JsonResult ListarPlanesClases()
        {
            try
            {
                var usuario = (USUARIOS)Session["UsuarioAutenticado"];
                if (usuario == null) return Json(new { success = false, message = "Sesión expirada" });

                int resultado;
                string mensaje;
                List<PLANCLASESDIARIO> lst = new List<PLANCLASESDIARIO>();
                lst = CN_PlanClasesDiario.ListarPlanesClases(usuario.id_usuario, out resultado, out mensaje);

                return Json(new { data = lst, resultado = resultado, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        // Vista Crear Plan de Clases Diario
        [HttpGet]
        public ActionResult CrearPlanClasesDiario()
        {
            return View();
        }

        // Vista Detalle del Plan de Clases Diario
        [HttpGet]
        public ActionResult DetallePlanDiario(int id)
        {
            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
            PLANCLASESDIARIO plan = CN_PlanClasesDiario.ObtenerPlanDiarioPorId(id, usuario.id_usuario);

            if (plan == null || usuario == null)
            {
                ViewBag["Error"] = "El plan de clases no existe.";
                return RedirectToAction("Plan_de_Clases_Diario");
            }

            return View(plan);
        }

        // Vista Editar del Plan de Clases Diario
        [HttpGet]
        public ActionResult EditarPlanDiario(int id)
        {
            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
            PLANCLASESDIARIO plan = CN_PlanClasesDiario.ObtenerPlanDiarioPorId(id, usuario.id_usuario);

            if (plan == null || usuario == null)
            {
                ViewBag["Error"] = "El plan de clases no existe.";
                return RedirectToAction("Plan_de_Clases_Diario");
            }

            return View(plan);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult GuardarPlanDiario(PLANCLASESDIARIO plan)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return View("Plan_de_Clases_Diario", plan);
                }

                string mensaje;
                int resultado;
                bool esNuevo = plan.id_plan_diario == 0;

                USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
                
                plan.fk_profesor = usuario.id_usuario;

                if (esNuevo)
                {
                    resultado = CN_PlanClasesDiario.Registra(plan, out mensaje);
                }
                else
                {
                    resultado = CN_PlanClasesDiario.Editar(plan, out mensaje);
                }

                if (resultado <= 0)
                {
                    TempData["Error"] = $"No se pudo {(esNuevo ? "registrar" : "actualizar")} el plan. {mensaje}";
                    return View("Plan_de_Clases_Diario", plan);
                }

                TempData["Success"] = mensaje;
                return RedirectToAction("Plan_de_Clases_Diario");
            }
            catch (Exception)
            {
                TempData["Error"] = "Ocurrió un error inesperado al procesar su solicitud.";
                return RedirectToAction("Plan_de_Clases_Diario", new { id = plan?.id_plan_diario ?? 0 });
            }
        }

        // Enpoint(POST): Eliminar plan de clases diario
        [HttpPost]
        public JsonResult EliminarPlanClasesDiario(int id_plan_diario)
        {
            string mensaje = string.Empty;
            var usuario = (USUARIOS)Session["UsuarioAutenticado"];
            if (usuario == null) return Json(new { success = false, message = "Sesión expirada" });

            int resultado = CN_PlanClasesDiario.Eliminar(id_plan_diario, usuario.id_usuario, out mensaje);

            return Json(new { Respuesta = (resultado == 1), Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        #endregion
    }
}