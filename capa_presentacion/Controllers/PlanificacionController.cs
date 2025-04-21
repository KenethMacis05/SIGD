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
        public ActionResult Matriz_de_Integracion()
        {
            return View();
        }
        public ActionResult Plan_Didactico_Semestral()
        {
            return View();
        }
        public ActionResult Plan_de_Clases_Diario()
        {
            return View();
        }
    }
}