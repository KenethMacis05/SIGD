using capa_entidad;
using capa_negocio;
using capa_presentacion.Filters;
using System;
using System.Collections.Generic;
using System.Drawing.Drawing2D;
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
        CN_PlanSemestral CN_PlanSemestral = new CN_PlanSemestral();
        CN_MatrizIntegracionComponentes CN_MatrizIntegradora = new CN_MatrizIntegracionComponentes();
        CN_MatrizAsignatura CN_MatrizAsignatura = new CN_MatrizAsignatura();
        CN_Contenidos CN_Contenidos = new CN_Contenidos();
        CN_AccionIntegradoraTipoEvaluaciona CN_AccionIntegradoraTipoEvaluaciona = new CN_AccionIntegradoraTipoEvaluaciona();
        CN_Semanas CN_Semanas = new CN_Semanas();
        CN_TemasPlanificacionSemestral CN_TemasPlanificacionSemestral = new CN_TemasPlanificacionSemestral();
        CN_PlanIndividual CN_PlanIndividual = new CN_PlanIndividual();

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

                List<MATRIZINTEGRACIONCOMPONENTES> lst = CN_MatrizIntegradora.Listar(usuario.id_usuario, out resultado, out mensaje);
                
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
        public ActionResult EditarMatrizIntegracion(string idEncriptado)
        {
            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
            MATRIZINTEGRACIONCOMPONENTES matriz = CN_MatrizIntegradora.ObtenerMatrizPorId(idEncriptado, usuario.id_usuario);
            if (matriz == null || usuario == null)
            {
                ViewBag["Error"] = "La matriz de integración no existe.";
                return RedirectToAction("Matriz_de_Integracion");
            }
            return View(matriz);
        }

        // Guardar Matriz de Integracion de Componentes
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

        ////////////////////////////////////////////////////////////////////////////////////
        //  Semanas de la matriz de integracion  //
        ///////////////////////////////////////////////////////////////////////////////////

        [HttpGet]
        public ActionResult SemanasMatriz(string idEncriptado)
        {
            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
            
            // Obtener la matriz principal
            MATRIZINTEGRACIONCOMPONENTES matriz = CN_MatrizIntegradora.ObtenerMatrizPorId(idEncriptado, usuario.id_usuario);

            if (matriz == null || usuario == null)
            {
                TempData["Error"] = "La matriz de integración no existe.";
                return RedirectToAction("Matriz_de_Integracion");
            }
            
            // Obtener las semanas de la matriz
            //int resultado;
            //string mensaje;
            //var semanas = CN_Semanas.Listar(idEncriptado, out resultado, out mensaje);
            //ViewBag.Semanas = semanas;
            //ViewBag.MensajeSemanas = mensaje;

            return View(matriz);
        }

        [HttpGet]
        public JsonResult ListarSemanasMatriz(string idEncriptado)
        {
            try
            {
                int resultado;
                string mensaje;
                List<SEMANAS> semanas = CN_Semanas.Listar(idEncriptado, out resultado, out mensaje);
                return Json(new { data = semanas, resultado = resultado,  mensaje = mensaje }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, data = new List<SEMANAS>(), mensaje = "Error: " + ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public JsonResult GuardarSemanaMatriz(SEMANAS semana)
        {
            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
            if (usuario == null)
            {
                return Json(new { success = false, message = "La sesión ha expirado. Por favor, inicie sesión nuevamente." });
            }
            string mensaje = string.Empty;
            int resultado = 0;
            if (semana.id_semana == 0)
            {
                // Crear nueva semana
                resultado = CN_Semanas.Crear(semana, out mensaje);
            }
            else
            {
                // Actualizar semana existente
                resultado = CN_Semanas.Actualizar(semana, out mensaje);
            }
            return Json(new { Resultado = resultado, Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        ////////////////////////////////////////////////////////////////////////////////////
        //  Asignaturas para la Matriz de Integracion de Componentes  //
        ///////////////////////////////////////////////////////////////////////////////////

        //Vista Asignar asignaturas a la Matriz de Integracion de Componentes
        [HttpGet]
        public ActionResult AsignarAsignaturasMatrizIntegracion(string idEncriptado)
        {
            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];

            // Validar usuario autenticado
            if (usuario == null)
            {
                TempData["Error"] = "Debe iniciar sesión para acceder a esta funcionalidad.";
                return RedirectToAction("Login", "Autenticacion");
            }

            // Obtener la matriz principal
            MATRIZINTEGRACIONCOMPONENTES matriz = CN_MatrizIntegradora.ObtenerMatrizPorId(idEncriptado, usuario.id_usuario);

            // Validar si la matriz existe
            if (matriz == null)
            {
                TempData["Error"] = "La matriz de integración no existe o no tiene permisos para acceder a ella.";
                return RedirectToAction("Matriz_de_Integracion");
            }

            // Validar permisos específicos (redundante pero segura)
            if (matriz.fk_profesor != usuario.id_usuario)
            {
                TempData["Error"] = "Usted no tiene permisos en esta Matriz.";
                return RedirectToAction("Matriz_de_Integracion");
            }

            // Obtener las asignaturas asignadas a esta matriz
            int resultado;
            string mensaje;
            var asignaturas = CN_MatrizAsignatura.ListarAsignaturasPorMatriz(idEncriptado, out resultado, out mensaje);

            ViewBag.Asignaturas = asignaturas;
            ViewBag.MensajeAsignaturas = mensaje;

            return View(matriz);
        }

        // Endpoint para cargar asignaturas via AJAX
        [HttpGet]
        public JsonResult ListarMatrizAsignaturaPorId(string idEncriptado)
        {
            try
            {
                int resultado;
                string mensaje;

                var asignaturas = CN_MatrizAsignatura.ListarAsignaturasPorMatriz(idEncriptado, out resultado, out mensaje);

                return Json(new { success = resultado == 1, data = asignaturas, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, data = new List<MATRIZASIGNATURA>(), mensaje = "Error: " + ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpGet]
        public JsonResult ListarAsignaturaAsignadas()
        {
            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];

            try
            {
                int resultado;
                string mensaje;

                var asignaturas = CN_MatrizAsignatura.ListarAsignaturasPorProfesor(usuario.id_usuario, out resultado, out mensaje);

                return Json(new { success = resultado == 1, data = asignaturas, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, data = new List<MATRIZASIGNATURA>(), mensaje = "Error: " + ex.Message }, JsonRequestBehavior.AllowGet);
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

        // Endpoint(POST): Eliminar asignatura de la asignatura
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

        ////////////////////////////////////////////////////////////////////////////////////
        //  Contenidos para las asignaturas de la Matriz de Integracion de Componentes  //
        ///////////////////////////////////////////////////////////////////////////////////

        [HttpGet]
        public ActionResult Contenidos(string idEncriptado)
        {
            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];

            // Obtener la asignatura selecionada de la matriz
            MATRIZASIGNATURA asignatura = CN_MatrizAsignatura.ObtenerAsignaturaDelaMatrizPorId(idEncriptado);
            MATRIZINTEGRACIONCOMPONENTES matriz = CN_MatrizIntegradora.ObtenerMatrizPorId(asignatura.fk_matriz_integracion_encriptado, usuario.id_usuario);

            if (asignatura == null || usuario == null)
            {
                TempData["Error"] = "La asignatura no esta asignada a esta matris de integración.";
                return RedirectToAction("Matriz_de_Integracion");
            }

            if (asignatura.fk_profesor_asignado != usuario.id_usuario && matriz.fk_profesor != usuario.id_usuario)
            {
                TempData["Error"] = "Usted no tiene permisos en esta asignatura.";
                return RedirectToAction("Matriz_de_Integracion");
            }

            // Obtener las semanas de las asignatura asignada a esta matriz
            int resultado;
            string mensaje;
            var contenido = CN_Contenidos.Listar(idEncriptado, out resultado, out mensaje);

            ViewBag.Contenidos = contenido;
            ViewBag.MensajeSemanas = mensaje;

            return View(asignatura);
        }

        public ActionResult ContenidosPorSemana(string idEncriptado, int semana)
        {
            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];

            // Validar usuario autenticado
            if (usuario == null)
            {
                TempData["Error"] = "Debe iniciar sesión para acceder a esta funcionalidad.";
                return RedirectToAction("Login", "Autenticacion");
            }

            // Obtener la matriz principal
            MATRIZINTEGRACIONCOMPONENTES matriz = CN_MatrizIntegradora.ObtenerMatrizPorId(idEncriptado, usuario.id_usuario);

            // Obtener contenidos de las asignaturas por semana
            int resultado;
            string mensaje;
            var contenidos = CN_Contenidos.ObtenerContenidosPorSemana(idEncriptado, semana, out resultado, out mensaje);

            ViewBag.Contenidos = contenidos;
            ViewBag.Semana = semana;
            ViewBag.MensajeContenidos = mensaje;

            return View(matriz);
        }

        // Endpoint para cargar los contenidos via AJAX
        [HttpGet]
        public JsonResult ListarContenidosPorId(string idEncriptado)
        {
            try
            {
                int resultado;
                string mensaje;

                var contenido = CN_Contenidos.Listar(idEncriptado, out resultado, out mensaje);

                return Json(new { success = resultado == 1, data = contenido, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, data = new List<CONTENIDOS>(), mensaje = "Error: " + ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public JsonResult GuardarContenido(CONTENIDOS contenido)
        {
            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
            if (usuario == null)
            {
                return Json(new { success = false, message = "La sesión ha expirado. Por favor, inicie sesión nuevamente." });
            }

            string mensaje = string.Empty;
            int resultado = 0;

            if (contenido.id_contenido == 0)
            {
                // Crear nueva semana
                resultado = CN_Contenidos.Crear(contenido, out mensaje);
            }
            else
            {
                // Actualizar semana existente
                resultado = CN_Contenidos.Actualizar(contenido, out mensaje);
            }

            return Json(new { Resultado = resultado, Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        ////////////////////////////////////////////////////////////////////////////////////
        //  Asignaturas asignadas al docente  //
        ///////////////////////////////////////////////////////////////////////////////////
        
        public ActionResult Asignaturas_Asignadas()
        {
            return View();
        }

        ////////////////////////////////////////////////////////////////////////////////////
        //  Acción integradora y tipo de evaluación  //
        ///////////////////////////////////////////////////////////////////////////////////

        //Vista acción integradora y tipo de evaluación
        [HttpGet]
        public ActionResult AccionIntegradoraTipoEvaluacion(string idEncriptado)
        {
            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];

            // Validar usuario autenticado
            if (usuario == null)
            {
                TempData["Error"] = "Debe iniciar sesión para acceder a esta funcionalidad.";
                return RedirectToAction("Login", "Autenticacion");
            }

            // Obtener la matriz principal
            MATRIZINTEGRACIONCOMPONENTES matriz = CN_MatrizIntegradora.ObtenerMatrizPorId(idEncriptado, usuario.id_usuario);

            // Validar si la matriz existe
            if (matriz == null)
            {
                TempData["Error"] = "La matriz de integración no existe o no tiene permisos para acceder a ella.";
                return RedirectToAction("Matriz_de_Integracion");
            }

            // Validar permisos específicos (redundante pero segura)
            if (matriz.fk_profesor != usuario.id_usuario)
            {
                TempData["Error"] = "Usted no tiene permisos en esta Matriz.";
                return RedirectToAction("Matriz_de_Integracion");
            }

            // Obtener las acción integradora y tipo de evaluación
            int resultado;
            string mensaje;
            var accionIntegradoraTipoEvaluacion = CN_AccionIntegradoraTipoEvaluaciona.ListarPorMatriz(idEncriptado, out resultado, out mensaje);

            ViewBag.accionIntegradoraTipoEvaluacion = accionIntegradoraTipoEvaluacion;
            ViewBag.Mensaje = mensaje;

            return View(matriz);
        }

        [HttpGet]
        public JsonResult ListarAccionIntegradoraTipoEvaluacionPorId(string idEncriptado)
        {
            try
            {
                int resultado;
                string mensaje;

                var accionIntegradoraTipoEvaluacion = CN_AccionIntegradoraTipoEvaluaciona.ListarPorMatriz(idEncriptado, out resultado, out mensaje);

                return Json(new { success = resultado == 1, data = accionIntegradoraTipoEvaluacion, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, data = new List<ACCIONINTEGRADORA_TIPOEVALUACION>(), mensaje = "Error: " + ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public JsonResult GuardarAccionIntegradoraTipoEvaluacion(ACCIONINTEGRADORA_TIPOEVALUACION accionTipo)
        {
            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
            if (usuario == null)
            {
                return Json(new { success = false, message = "La sesión ha expirado. Por favor, inicie sesión nuevamente." });
            }

            string mensaje = string.Empty;
            int resultado = 0;

            if (accionTipo.id_accion_tipo == 0)
            {
                resultado = CN_AccionIntegradoraTipoEvaluaciona.Crear(accionTipo, out mensaje);
            }
            else
            {
                resultado = CN_AccionIntegradoraTipoEvaluaciona.Actualizar(accionTipo, out mensaje);
            }

            return Json(new { Resultado = resultado, Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }



        #endregion

        #region Plan Didactico Semestral

        public ActionResult Plan_Didactico_Semestral()
        {
            return View();
        }

        //Vista Crear plan de didactico semestral
        [HttpGet]
        public ActionResult CrearPlanDidactico()
        {
            return View();
        }

        //Vista Editar de la Matriz de Integracion de Componentes
        [HttpGet]
        public ActionResult EditarPlanDidactico(string idEncriptado)
        {
            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
            string mensaje = string.Empty;

            PLANDIDACTICOSEMESTRAL planSemestral = CN_PlanSemestral.ObtenerPlanSemestralPorId(idEncriptado, usuario.id_usuario, out mensaje);
            if (planSemestral == null || usuario == null)
            {
                ViewBag["Error"] = mensaje;
                return RedirectToAction("Plan_Didactico_Semestral");
            }
            return View(planSemestral);
        }

        public JsonResult BuscarMatrizAsignatura(int periodo)
        {
            var usuarioAsignado = (USUARIOS)Session["UsuarioAutenticado"];
            if (usuarioAsignado == null) return Json(new { success = false, message = "Sesión expirada" }, JsonRequestBehavior.AllowGet);

            string mensaje = string.Empty;
            List<MATRIZASIGNATURA> lst = CN_MatrizAsignatura.BuscarMatriz(periodo, usuarioAsignado.id_usuario, out mensaje);

            return Json(new { data = lst, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        //Enpoint(GET): Listar matrices de integracion del usuario
        [HttpGet]
        public JsonResult ListarDatosGeneralesPlanSemestral()
        {
            try
            {
                var usuario = (USUARIOS)Session["UsuarioAutenticado"];
                if (usuario == null) return Json(new { success = false, message = "Sesión expirada" }, JsonRequestBehavior.AllowGet);

                int resultado;
                string mensaje;

                List<PLANDIDACTICOSEMESTRAL> lst = CN_PlanSemestral.ListarDatosGenerales(usuario.id_usuario, out resultado, out mensaje);

                return Json(new { data = lst, resultado = resultado, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult GuardarPlanDidactico(PLANDIDACTICOSEMESTRAL pds)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return View("Plan_Didactico_Semestral", pds);
                }

                string mensaje;
                int resultado;
                bool esNuevo = pds.id_plan_didactico == 0;

                // 1. Guardar la matriz principal
                if (esNuevo)
                {
                    resultado = CN_PlanSemestral.Crear(pds, out mensaje);
                }
                else
                {
                    resultado = CN_PlanSemestral.Editar(pds, out mensaje);
                }

                if (resultado <= 0)
                {
                    TempData["Error"] = $"No se pudo {(esNuevo ? "registrar" : "actualizar")} el plan semestral. {mensaje}";
                    return View("Plan_Didactico_Semestral", pds);
                }

                TempData["Success"] = mensaje;
                return RedirectToAction("Plan_Didactico_Semestral");
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Ocurrió un error inesperado al procesar su solicitud: " + ex.Message;
                return RedirectToAction("Plan_Didactico_Semestral", new { id = pds?.id_plan_didactico ?? 0 });
            }
        }

        [HttpPost]
        public JsonResult EliminarPlanDidactico(int id_plan_semestral)
        {
            string mensaje = string.Empty;
            int resultado = CN_PlanSemestral.Eliminar(id_plan_semestral, out mensaje);
            return Json(new { Respuesta = (resultado == 1), Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        // TEMAS DEL PLAN SEMESTRAL
        [HttpGet]
        public ActionResult TemasPlanSemestral(string idEncriptado)
        {
            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
            string mensaje = string.Empty;

            PLANDIDACTICOSEMESTRAL planSemestral = CN_PlanSemestral.ObtenerPlanSemestralPorId(idEncriptado, usuario.id_usuario, out mensaje);
            if (planSemestral == null || usuario == null)
            {
                ViewBag["Error"] = mensaje;
                return RedirectToAction("Plan_Didactico_Semestral");
            }
            return View(planSemestral);
        }

        [HttpGet]
        public JsonResult ListarTemasPlanSemestral(string idEncriptado)
        {
            try
            {
                int resultado;
                string mensaje;
                List<TEMAPLANIFICACIONSEMESTRAL> temas = CN_TemasPlanificacionSemestral.Listar(idEncriptado, out resultado, out mensaje);
                return Json(new { data = temas, resultado = resultado, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, data = new List<TEMAPLANIFICACIONSEMESTRAL>(), mensaje = "Error: " + ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public JsonResult GuardarTemasPlanSemestral(TEMAPLANIFICACIONSEMESTRAL tema)
        {
            string mensaje = string.Empty;
            int resultado = 0;

            if (tema.id_tema == 0)
            {
                resultado = CN_TemasPlanificacionSemestral.Crear(tema, out mensaje);
            }
            else
            {
                resultado = CN_TemasPlanificacionSemestral.Editar(tema, out mensaje);
            }

            return Json(new { Resultado = resultado, Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        public JsonResult EliminarTemasPlanSemestral(int id_tema)
        {
            string mensaje = string.Empty;
            int resultado = CN_TemasPlanificacionSemestral.Eliminar(id_tema, out mensaje);
            return Json(new { Respuesta = (resultado == 1), Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        // PLANIFICACION INDIVIDUAL
        [HttpGet]
        public ActionResult Planificacion_Individual(string idEncriptado)
        {
            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
            string mensaje = string.Empty;

            PLANDIDACTICOSEMESTRAL planSemestral = CN_PlanSemestral.ObtenerPlanSemestralPorId(idEncriptado, usuario.id_usuario, out mensaje);
            if (planSemestral == null || usuario == null)
            {
                ViewBag["Error"] = mensaje;
                return RedirectToAction("Plan_Didactico_Semestral");
            }
            return View(planSemestral);
        }

        [HttpGet]
        public JsonResult ListarPlanificacionIndividual(string idEncriptado)
        {
            try
            {
                int resultado;
                string mensaje;
                var planificacionIndividual = CN_PlanIndividual.Listar(idEncriptado, out resultado, out mensaje);
                return Json(new { success = resultado == 1, data = planificacionIndividual, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, data = new List<PLANIFICACIONINDIVIDUALSEMESTRAL>(), mensaje = "Error: " + ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public JsonResult GuardarPlanificacionIndividual(PLANIFICACIONINDIVIDUALSEMESTRAL PlanIndividual)
        {
            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
            if (usuario == null)
            {
                return Json(new { success = false, message = "La sesión ha expirado. Por favor, inicie sesión nuevamente." });
            }

            string mensaje = string.Empty;
            int resultado = 0;

            if (PlanIndividual.id_planificacion == 0)
            {
                // Crear nuevo plan
                resultado = CN_PlanIndividual.Crear(PlanIndividual, out mensaje);
            }
            else
            {
                // Actualizar plan
                resultado = CN_PlanIndividual.Actualizar(PlanIndividual, out mensaje);
            }

            return Json(new { Resultado = resultado, Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
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