using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace capa_presentacion.Controllers
{
    public class ConfiguracionController : Controller
    {        
        [HttpGet]
        public JsonResult ObtenerTiposArchivosPermitidos()
        {
            string tiposPermitidos = ConfigurationManager.AppSettings["TiposArchivosPermitidos"];
            return Json(new { tiposPermitidos }, JsonRequestBehavior.AllowGet);
        }

        // Endpoint para actualizar los tipos de archivos permitidos
        [HttpPost]
        public JsonResult ActualizarTiposArchivosPermitidos(string nuevosTipos)
        {
            try
            {
                if (string.IsNullOrEmpty(nuevosTipos))
                {
                    return Json(new { exito = false, mensaje = "La lista de tipos de archivos no puede estar vacía." });
                }

                // Actualizar el valor en web.config
                Configuration config = System.Web.Configuration.WebConfigurationManager.OpenWebConfiguration("~");
                config.AppSettings.Settings["TiposArchivosPermitidos"].Value = nuevosTipos;
                config.Save(ConfigurationSaveMode.Modified);

                return Json(new { exito = true, mensaje = "Tipos de archivos permitidos actualizados correctamente." });
            }
            catch (Exception ex)
            {
                return Json(new { exito = false, mensaje = "Ocurrió un error al actualizar los tipos de archivos: " + ex.Message });
            }
        }
    }
}