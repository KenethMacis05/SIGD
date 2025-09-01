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
    public class CatalogosController : Controller
    {
        CN_AreaConocimiento CN_AreaConocimiento = new CN_AreaConocimiento();
        CN_Departamento CN_Departamento = new CN_Departamento();
        CN_Carrera CN_Carrera = new CN_Carrera();
        CN_Asignatura CN_Asignatura = new CN_Asignatura();
        CN_Periodo CN_Periodo = new CN_Periodo();

        #region Areas de Conocimiento

        // Vista: Área de Conocimiento
        public ActionResult AreaConocimiento()
        {
            return View();
        }

        // Enpoint(GET): listar los áreas de conocimiento
        [HttpGet]
        public JsonResult ListarAreasDeConocimiento()
        {
            List<AREACONOCIMIENTO> lst = new List<AREACONOCIMIENTO>();
            lst = CN_AreaConocimiento.Listar();

            return Json(new { data = lst }, JsonRequestBehavior.AllowGet);
        }

        #endregion

        #region Departamento

        // Vista: Departamento
        public ActionResult Departamento()
        {
            return View();
        }

        // Enpoint(GET): listar los departamentos
        [HttpGet]
        public JsonResult ListarDepartamentos()
        {
            List<DEPARTAMENTO> lst = new List<DEPARTAMENTO>();
            lst = CN_Departamento.Listar();

            return Json(new { data = lst }, JsonRequestBehavior.AllowGet);
        }

        #endregion

        #region Carrera

        // Vista: Carrera
        public ActionResult Carrera()
        {
            return View();
        }

        // Enpoint(GET): listar las carreras
        [HttpGet]
        public JsonResult ListarCarreras()
        {
            List<CARRERA> lst = new List<CARRERA>();
            lst = CN_Carrera.Listar();

            return Json(new { data = lst }, JsonRequestBehavior.AllowGet);
        }

        #endregion

        #region Componente

        // Vista: Componente
        public ActionResult Componente()
        {
            return View();
        }

        // Enpoint(GET): listar las asignaturas
        [HttpGet]
        public JsonResult ListarAsignaturas()
        {
            List<ASIGNATURA> lst = new List<ASIGNATURA>();
            lst = CN_Asignatura.Listar();

            return Json(new { data = lst }, JsonRequestBehavior.AllowGet);
        }

        #endregion

        #region Periodo

        // Vista: Periodo
        public ActionResult Periodo()
        {
            return View();
        }

        // Enpoint(GET): listar los departamentos
        [HttpGet]
        public JsonResult ListarPeriodos()
        {
            List<PERIODO> lst = new List<PERIODO>();
            lst = CN_Periodo.Listar();

            return Json(new { data = lst }, JsonRequestBehavior.AllowGet);
        }

        #endregion
    }
}
