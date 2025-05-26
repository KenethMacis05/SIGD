using capa_entidad;
using capa_negocio;
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
        CN_Archivo CN_Archivo = new CN_Archivo();

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


        public bool SubirArchivoConCarpeta(HttpPostedFileBase archivoSubido, int idCarpeta, int idUsuario, out string mensaje)
        {
            mensaje = string.Empty;
            string rutaCarpeta, mensajeRuta;

            // 1. Validar tipo y tamaño
            string extension = Path.GetExtension(archivoSubido.FileName);
            if (!ValidarTipoArchivo(extension, out mensaje))
                return false;
            if (!ValidarTamañoArchivo(archivoSubido, out mensaje))
                return false;

            // 2. Obtener ruta real de la carpeta destino
            CN_Carpeta cnCarpeta = new CN_Carpeta();
            if (!cnCarpeta.ObtenerRutaCarpetaPorId(idCarpeta, out rutaCarpeta, out mensajeRuta))
            {
                mensaje = "No se pudo obtener la ruta de la carpeta destino. " + mensajeRuta;
                return false;
            }

            // 3. Mapear ruta física y crear carpetas si no existen
            string rutaBase = ConfigurationManager.AppSettings["ServidorArchivos"];
            string rutaFisica = HttpContext.Current.Server.MapPath(rutaCarpeta);

            if (!Directory.Exists(rutaFisica))
                Directory.CreateDirectory(rutaFisica);

            // 4. Guardar archivo físicamente
            string nombreArchivo = Path.GetFileName(archivoSubido.FileName);
            string rutaArchivoFisica = Path.Combine(rutaFisica, nombreArchivo);
            archivoSubido.SaveAs(rutaArchivoFisica);

            // 5. Guardar en base de datos
            ARCHIVO archivo = new ARCHIVO
            {
                nombre = nombreArchivo,
                tipo = extension,
                size = archivoSubido.ContentLength,
                ruta = Path.Combine(rutaCarpeta, nombreArchivo),
                id_usuario = idUsuario,
                id_carpeta = idCarpeta
            };

            int resultado = CN_Archivo.SubirArchivo(archivo, out mensaje);
            if (resultado == 0)
            {
                mensaje = "El archivo no se pudo guardar en la base de datos.";
                return false;
            }

            mensaje = "Archivo subido correctamente.";
            return true;
        }

        // Métodos auxiliares: Puedes llevar los que ya tienes aquí o dejarlos estáticos
        private bool ValidarTamañoArchivo(HttpPostedFileBase archivoSubido, out string mensaje)
        {
            mensaje = string.Empty;
            if (archivoSubido.ContentLength > 10 * 1024 * 1024)
            {
                mensaje = "El archivo no debe superar los 10 MB.";
                return false;
            }
            return true;
        }

        private bool ValidarTipoArchivo(string extensionArchivo, out string mensaje)
        {
            mensaje = string.Empty;
            string tiposPermitidos = ConfigurationManager.AppSettings["TiposArchivosPermitidos"];
            if (string.IsNullOrEmpty(tiposPermitidos))
            {
                mensaje = "No se han configurado tipos de archivos permitidos.";
                return false;
            }
            List<string> listaTiposPermitidos = tiposPermitidos.Split(',').Select(t => t.Trim().ToLower()).ToList();
            if (!listaTiposPermitidos.Contains(extensionArchivo.ToLower()))
            {
                mensaje = $"El tipo de archivo '{extensionArchivo}' no está permitido.";
                return false;
            }
            return true;
        }
    }
}