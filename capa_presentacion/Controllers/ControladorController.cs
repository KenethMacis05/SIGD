using capa_entidad;
using capa_negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace capa_presentacion.Controllers
{
    public class ControladorController : Controller
    {        
        private readonly CN_Controlador objControlador = new CN_Controlador();

        // Enpoint(GET): Vista inicial del controlador
        [HttpGet]
        public ActionResult Index()
        {
            return View();
        }

        // Enpoint(GET): Listar controladores
        [HttpGet]
        public JsonResult listarControladores()
        {
            List<CONTROLLER> lst = new List<CONTROLLER>();
            lst = objControlador.Listar();

            return Json(new { data = lst }, JsonRequestBehavior.AllowGet);
        }
    }
}