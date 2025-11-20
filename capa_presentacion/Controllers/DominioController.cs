using capa_datos;
using capa_entidad;
using capa_negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace capa_presentacion.Controllers
{
    public class DominioController : Controller
    {
        private readonly CN_DominioRol objDominioRol = new CN_DominioRol();

        // Enpoint(GET): Listar dominios por rol
        [AllowAnonymous]
        [HttpGet]
        public JsonResult ObtenerDominiosPorRol(int IdRol, int IdDominio)
        {
            List<DOMINIOROL> lst = new List<DOMINIOROL>();
            lst = objDominioRol.ListarDominiosPorRol(IdRol, IdDominio);

            return Json(new { data = lst }, JsonRequestBehavior.AllowGet);
        }

        // Enpoint(GET): Listar dominios no asignados por rol
        [AllowAnonymous]
        [HttpGet]
        public JsonResult ObtenerDominioNoAsignados(int IdRol, int IdDominio)
        {
            List<DOMINIO> lst = new List<DOMINIO>();
            lst = objDominioRol.ListarDominiosNoAsignados(IdRol, IdDominio);

            return Json(new { data = lst }, JsonRequestBehavior.AllowGet);
        }

        // Enpoint(POST): Asignar dominios a un rol
        [AllowAnonymous]
        [HttpPost]
        public JsonResult AsignarDominio(int IdRol, List<int> IdsDominios)
        {
            try
            {
                var resultados = objDominioRol.AsignarDominio(IdRol, IdsDominios);

                var data = resultados.Select(r => new {
                    IdDominio = r.Key,
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

        // Enpoint(POST): Quitar dominio de un rol
        [AllowAnonymous]
        [HttpPost]
        public JsonResult QuitarDominio(List<int> IdsDominios)
        {
            try
            {
                string mensaje = string.Empty;
                var resultados = objDominioRol.QuitarDominioAsignado(IdsDominios, out mensaje);

                var data = resultados.Select(r => new {
                    IdDominio = r.Key,
                    Codigo = r.Value.Codigo,
                    Mensaje = r.Value.Mensaje,
                    EsExitoso = r.Value.Codigo > 0
                }).ToList();

                return Json(new
                {
                    success = true,
                    mensaje = mensaje,
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

        // Enpoint(POST): Guardar dominios asignados a un rol (Reemplazar)
        [AllowAnonymous]
        [HttpPost]
        public JsonResult GuardarDominiosRol(int IdRol, List<int> Dominios, int? IdTipoDominio = null, string TipoDominio = null)
        {
            try
            {
                var resultado = objDominioRol.ReemplazarDominiosRol(IdRol, Dominios, IdTipoDominio, TipoDominio);

                return Json(new
                {
                    success = resultado.Success,
                    message = resultado.Message
                });
            }
            catch (Exception ex)
            {
                return Json(new
                {
                    success = false,
                    message = "Error: " + ex.Message
                });
            }
        }
    }
}