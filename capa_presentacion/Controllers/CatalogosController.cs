﻿using capa_entidad;
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

        // Enpoint(POST): Guardar o editar área de conocimiento
        [HttpPost]
        public JsonResult GuardarAreaDeConocimiento(AREACONOCIMIENTO area)
        {
            string mensaje = string.Empty;
            int resultado = 0;

            if (area.id_area == 0)
            {
                resultado = CN_AreaConocimiento.Crear(area, out mensaje);
            }
            else
            {
                resultado = CN_AreaConocimiento.Editar(area, out mensaje);
            }

            return Json(new { Resultado = resultado, Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        // Enpoint(POST): Eliminar área de conocimiento
        [HttpPost]
        public JsonResult EliminarAreasDeConocimiento(int IdArea)
        {
            string mensaje = string.Empty;
            int resultado = CN_AreaConocimiento.Eliminar(IdArea, out mensaje);
            return Json(new { Respuesta = (resultado == 1), Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
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

        // Enpoint(POST): Guardar o editar departamento
        [HttpPost]
        public JsonResult GuardarDepartamentos(DEPARTAMENTO departamento)
        {
            string mensaje = string.Empty;
            int resultado = 0;

            if (departamento.id_departamento == 0)
            {
                resultado = CN_Departamento.Crear(departamento, out mensaje);
            }
            else
            {
                resultado = CN_Departamento.Editar(departamento, out mensaje);
            }

            return Json(new { Resultado = resultado, Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        // Enpoint(POST): Eliminar departamento
        [HttpPost]
        public JsonResult EliminarDepartamentos(int idDepartamento)
        {
            string mensaje = string.Empty;
            int resultado = CN_Departamento.Eliminar(idDepartamento, out mensaje);
            return Json(new { Respuesta = (resultado == 1), Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
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

        // Enpoint(POST): Guardar o editar carreras
        [HttpPost]
        public JsonResult GuardarCarreras(CARRERA carrera)
        {
            string mensaje = string.Empty;
            int resultado = 0;

            if (carrera.id_carrera == 0)
            {
                resultado = CN_Carrera.Crear(carrera, out mensaje);
            }
            else
            {
                resultado = CN_Carrera.Editar(carrera, out mensaje);
            }

            return Json(new { Resultado = resultado, Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        // Enpoint(POST): Eliminar carrera
        [HttpPost]
        public JsonResult EliminarCarreras(int idCarrera)
        {
            string mensaje = string.Empty;
            int resultado = CN_Carrera.Eliminar(idCarrera, out mensaje);
            return Json(new { Respuesta = (resultado == 1), Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
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
