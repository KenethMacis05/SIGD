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
        public bool CrearCarpeta(string carpeta, out string mensaje)
        {
            try
            {
                // Leer la ruta base desde el archivo Web.config
                string rutaGuardar = ConfigurationManager.AppSettings["ServidorArchivos"];
                if (string.IsNullOrEmpty(rutaGuardar))
                {
                    mensaje = "La configuración del servidor de archivos no está definida.";
                    return false;
                }

                // Mapear la ruta relativa a una ruta física absoluta
                string rutaFisica = HttpContext.Current.Server.MapPath(rutaGuardar);

                // Combinar la ruta física con el nombre de la carpeta
                string rutaCarpeta = Path.Combine(rutaFisica, carpeta);

                // Verificar si la carpeta ya existe
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