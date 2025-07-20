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
            int resultado;
            string mensaje;

            try
            {
                USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
                if (usuario == null)
                {
                    return Json(new { success = false, message = "Sesión expirada" }, JsonRequestBehavior.AllowGet);
                }

                List<PLANCLASESDIARIO> lst = new List<PLANCLASESDIARIO>();
                lst = CN_PlanClasesDiario.ListarPlanesClases(1, out resultado, out mensaje);

                return Json(new { data = lst, resultado = resultado, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message }, JsonRequestBehavior.AllowGet);
            }
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

        //[HttpPost]
        //[AllowAnonymous]
        //public ActionResult EditarPlanDiario(PLANCLASESDIARIO model)
        //{
        //    string mensaje;
        //    bool resultado = CN_PlanClasesDiario.EditarPlanDiario(model, out mensaje);

        //    if (resultado)
        //    {
        //        TempData["Success"] = "Plan de clases actualizado correctamente.";
        //        return RedirectToAction("Plan_de_Clases_Diario", new { id = model.id_plan_diario });
        //    }
        //    else
        //    {
        //        TempData["Error"] = mensaje;
        //        return View(model);
        //    }
        //}

        // Enpoint(POST): Eliminar plan de clases diario
        [HttpPost]
        public JsonResult EliminarPlanClasesDiario(int id_plan_diario)
        {
            bool respuesta = false;
            string mensaje = "";
            try
            {
                respuesta = CN_PlanClasesDiario.EliminarPlanClasesDiario(id_plan_diario, out mensaje);
            }
            catch (Exception ex)
            {
                mensaje = "Error al eliminar el plan de clases: " + ex.Message;
            }
            return Json(new { Respuesta = respuesta, Mensaje = mensaje });
        }

        #endregion
    }
}