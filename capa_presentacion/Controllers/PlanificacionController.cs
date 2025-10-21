using capa_entidad;
using capa_negocio;
using capa_presentacion.Filters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Services.Description;

namespace capa_presentacion.Controllers
{
    [VerificarSession]
    public class PlanificacionController : Controller
    {
        CN_PlanClasesDiario CN_PlanClasesDiario = new CN_PlanClasesDiario();
        CN_MatrizIntegracionComponentes CN_MatrizIntegradora = new CN_MatrizIntegracionComponentes();
        CN_MatrizAsignatura CN_MatrizAsignatura = new CN_MatrizAsignatura();

        #region Matriz de Integracion de Componentes
        
        public ActionResult Matriz_de_Integracion()
        {
            return View();
        }

        //Enpoint(GET): Listar matrices de integracion del usuario
        [HttpGet]
        public JsonResult ListarMatricesIntegracion()
        {
            try
            {
                var usuario = (USUARIOS)Session["UsuarioAutenticado"];
                if (usuario == null) return Json(new { success = false, message = "Sesión expirada" }, JsonRequestBehavior.AllowGet);

                int resultado;
                string mensaje;

                List<MATRIZINTEGRACIONCOMPONENTES> lst = new List<MATRIZINTEGRACIONCOMPONENTES>();
                lst = CN_MatrizIntegradora.Listar(usuario.id_usuario, out resultado, out mensaje);
                
                return Json(new { data = lst, resultado = resultado, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        //Vista Crear Matriz de Integracion de Componentes
        [HttpGet]
        public ActionResult CrearMatrizIntegracion()
        {
            return View();
        }

        //Vista Editar de la Matriz de Integracion de Componentes
        [HttpGet]
        public ActionResult EditarMatrizIntegracion(int id)
        {
            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
            MATRIZINTEGRACIONCOMPONENTES matriz = CN_MatrizIntegradora.ObtenerMatrizPorId(id, usuario.id_usuario);
            if (matriz == null || usuario == null)
            {
                ViewBag["Error"] = "La matriz de integración no existe.";
                return RedirectToAction("Matriz_de_Integracion");
            }
            return View(matriz);
        }

        //Vista Asignar asignaturas a la Matriz de Integracion de Componentes
        [HttpGet]
        public ActionResult AsignarAsignaturasMatrizIntegracion(int id)
        {
            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];

            // Obtener la matriz principal
            MATRIZINTEGRACIONCOMPONENTES matriz = CN_MatrizIntegradora.ObtenerMatrizPorId(id, usuario.id_usuario);
            if (matriz == null || usuario == null)
            {
                TempData["Error"] = "La matriz de integración no existe.";
                return RedirectToAction("Matriz_de_Integracion");
            }

            // Obtener las asignaturas asignadas a esta matriz
            int resultado;
            string mensaje;
            var asignaturas = CN_MatrizAsignatura.ListarAsignaturasPorMatriz(id, out resultado, out mensaje);

            ViewBag.Asignaturas = asignaturas;
            ViewBag.MensajeAsignaturas = mensaje;

            return View(matriz);
        }

        // Endpoint para cargar asignaturas via AJAX
        [HttpGet]
        public JsonResult ListarMatrizAsignaturaPorId(int id)
        {
            try
            {
                int resultado;
                string mensaje;

                var asignaturas = CN_MatrizAsignatura.ListarAsignaturasPorMatriz(id, out resultado, out mensaje);

                return Json(new { success = resultado == 1, data = asignaturas, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, data = new List<MATRIZASIGNATURA>(), mensaje = "Error: " + ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult GuardarMatrizIntegracion(MATRIZINTEGRACIONCOMPONENTES matriz, List<MATRIZASIGNATURA> asignaturas)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return View("Matriz_de_Integracion", matriz);
                }

                string mensaje;
                int resultado;
                bool esNuevo = matriz.id_matriz_integracion == 0;

                USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
                matriz.fk_profesor = usuario.id_usuario;

                // 1. Guardar la matriz principal
                if (esNuevo)
                {
                    resultado = CN_MatrizIntegradora.Crear(matriz, out mensaje);
                }
                else
                {
                    resultado = CN_MatrizIntegradora.Editar(matriz, out mensaje);
                }

                if (resultado <= 0)
                {
                    TempData["Error"] = $"No se pudo {(esNuevo ? "registrar" : "actualizar")} la matriz. {mensaje}";
                    return View("Matriz_de_Integracion", matriz);
                }

                TempData["Success"] = mensaje;
                return RedirectToAction("Matriz_de_Integracion");
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Ocurrió un error inesperado al procesar su solicitud: " + ex.Message;
                return RedirectToAction("Matriz_de_Integracion", new { id = matriz?.id_matriz_integracion ?? 0 });
            }
        }

        [HttpPost]
        public JsonResult GuardarAsignaturasMatriz(MATRIZASIGNATURA matriz)
        {

            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
            if (usuario == null)
            {
                return Json(new { success = false, message = "La sesión ha expirado. Por favor, inicie sesión nuevamente." });
            }

            matriz.fk_profesor_propietario = usuario.id_usuario;
            string mensaje = string.Empty;
            int resultado = 0;

            if (matriz.id_matriz_asignatura == 0)
            {
                // Crear nueva asignatura
                resultado = CN_MatrizAsignatura.Asignar(matriz, out mensaje);
            }
            else
            {
                // Actualizar asignatura existente
                resultado = CN_MatrizAsignatura.Actualizar(matriz, out mensaje);
            }

            return Json(new { Resultado = resultado, Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        //Enpoint(POST): Eliminar matriz de integracion de componentes
        [HttpPost]
        public JsonResult EliminarMatrizIntegracion(int id_matriz_integracion)
        {
            string mensaje = string.Empty;
            var usuario = (USUARIOS)Session["UsuarioAutenticado"];
            if (usuario == null) return Json(new { success = false, message = "Sesión expirada" });
            int resultado = CN_MatrizIntegradora.Eliminar(id_matriz_integracion, usuario.id_usuario, out mensaje);
            return Json(new { Respuesta = (resultado == 1), Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        // Endpoint(POST): Eliminar matriz de asignatura
        [HttpPost]
        public JsonResult EliminarMatrizAsignatura(int id_matriz)
        {
            try
            {
                USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
                if (usuario == null)
                {
                    return Json(new { Respuesta = false, Mensaje = "La sesión ha expirado" });
                }

                string mensaje = string.Empty;
                int resultado = CN_MatrizAsignatura.Eliminar(id_matriz, usuario.id_usuario, out mensaje);

                return Json(new { Respuesta = (resultado == 1), Mensaje = mensaje });
            }
            catch (Exception ex)
            {
                return Json(new { Respuesta = false, Mensaje = "Error al eliminar la asignatura: " + ex.Message });
            }
        }

        #endregion

        #region Plan Didactico Semestral

        public ActionResult Plan_Didactico_Semestral()
        {
            return View();
        }

        #endregion

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