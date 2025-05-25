using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;

namespace capa_presentacion.Services
{
    public class ArchivoService
    {
        public bool CrearCarpeta(string carpeta, out string mensaje, string ruta = null)
        {
            try
            {
                // Leer la ruta base desde Web.config (si no se pasa una ruta)
                string rutaBase = !string.IsNullOrEmpty(ruta)
                    ? ruta
                    : ConfigurationManager.AppSettings["ServidorArchivos"];

                if (string.IsNullOrEmpty(rutaBase))
                {
                    mensaje = "La configuración del servidor de archivos no está definida.";
                    return false;
                }

                // Mapear la ruta
                string rutaFisica = HttpContext.Current.Server.MapPath(rutaBase);

                // Combinar con el nombre de la carpeta
                string rutaCarpeta = Path.Combine(rutaFisica, carpeta);

                if (!Directory.Exists(rutaCarpeta))
                {
                    Directory.CreateDirectory(rutaCarpeta);
                    mensaje = $"Carpeta creada exitosamente en: {rutaCarpeta}";
                    return true;
                }
                else
                {
                    mensaje = "La carpeta ya existe.";
                    return false;
                }
            }
            catch (Exception ex)
            {
                mensaje = $"Error al crear la carpeta: {ex.Message}";
                return false;
            }
        }
    }
}