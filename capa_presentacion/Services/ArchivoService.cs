using capa_entidad;
using capa_negocio;
using capa_presentacion.webtoken;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net.NetworkInformation;
using System.Web;
using System.Web.Hosting;

namespace capa_presentacion.Services
{
    public class ArchivoVisualizacionResult
    {
        public bool Respuesta { get; set; }
        public string Mensaje { get; set; }
        public string TipoArchivo { get; set; }
        public string TextoBase64 { get; set; }
        public string Ruta { get; set; }
        public string Mime { get; set; }
        public object ConfigOnlyOffice { get; set; }
    }


    public class ArchivoService
    {
        CN_Archivo CN_Archivo = new CN_Archivo();
        CN_Carpeta CN_Carpeta = new CN_Carpeta();
        CN_Recursos CN_Recurso = new CN_Recursos();

        /// <summary> Crea una carpeta en el servidor de archivos.</summary>
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

        /// <summary> Subir un archivo a una carpeta específica o a la carpeta raíz del usuario.</summary>
        public bool SubirArchivoConCarpeta(HttpPostedFileBase archivoSubido, int idCarpeta, int idUsuario, out string mensaje)
        {
            mensaje = string.Empty;
            string rutaCarpeta, mensajeRuta;
            string nombreArchivo = Path.GetFileName(archivoSubido.FileName);
            string extension = Path.GetExtension(archivoSubido.FileName);

            // 1. Validar tipo y tamaño
            if (!ValidarTipoArchivo(extension, out mensaje))
                return false;
            if (!ValidarTamañoArchivo(archivoSubido, out mensaje))
                return false;

            // 2. Determinar la carpeta destino
            if (idCarpeta == 0)
            {
                // Obtener usuario de sesión
                USUARIOS usuario = (USUARIOS)HttpContext.Current.Session["UsuarioAutenticado"];
                if (usuario == null)
                {
                    mensaje = "Sesión expirada, vuelva a iniciar sesión.";
                    return false;
                }

                // Carpeta lógica raíz del usuario
                string carpetaDefault = $"DEFAULT_{usuario.usuario}";
                rutaCarpeta = Path.Combine(carpetaDefault); // Relativa a la raíz de archivos

                // Crear la carpeta física si no existe
                string rutaBase = ConfigurationManager.AppSettings["ServidorArchivos"];
                string rutaFisicaCarpeta = Path.Combine(HttpContext.Current.Server.MapPath(rutaBase), carpetaDefault);
                if (!Directory.Exists(rutaFisicaCarpeta))
                    Directory.CreateDirectory(rutaFisicaCarpeta);

                // Guardar archivo físicamente
                string rutaArchivoFisica = Path.Combine(rutaFisicaCarpeta, nombreArchivo);
                archivoSubido.SaveAs(rutaArchivoFisica);

                // Guardar en la BD: pasar null como id_carpeta para que el SP lo resuelva
                ARCHIVO archivo = new ARCHIVO
                {
                    nombre = nombreArchivo,
                    tipo = extension,
                    size = archivoSubido.ContentLength,
                    ruta = Path.Combine(rutaBase, rutaCarpeta, nombreArchivo),
                    id_usuario = idUsuario,
                    id_carpeta = null // El SP resuelve la carpeta raíz del usuario
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
            else
            {
                // 2. Obtener ruta real de la carpeta destino                
                if (!CN_Carpeta.ObtenerRutaCarpetaPorId(idCarpeta, out rutaCarpeta, out mensajeRuta))
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
        }

        /// <summary> Validar el tamaño del archivo a subir.</summary>
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

        /// <summary> Validar el tipo de archivo según la configuración.</summary>
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

        /// <summary> Visualizar un imagen.</summary>
        public ArchivoVisualizacionResult VisualizarImagen(int idArchivo, string extension)
        {
            bool conversion;
            string rutaArchivo, mensaje;
            if (!CN_Archivo.ObtenerRutaArchivoPorId(idArchivo, out rutaArchivo, out mensaje) || string.IsNullOrEmpty(rutaArchivo))
                return new ArchivoVisualizacionResult { Respuesta = false, Mensaje = "No se pudo encontrar la imagen: " + mensaje };

            string rutaFisicaArchivo = HostingEnvironment.MapPath(rutaArchivo);
            if (!File.Exists(rutaFisicaArchivo))
                return new ArchivoVisualizacionResult { Respuesta = false, Mensaje = "La imagen no existe en el servidor." };

            string base64 = CN_Recurso.ConvertBase64(rutaFisicaArchivo, out conversion);
            string mime = extension == ".png" ? "image/png" : extension == ".gif" ? "image/gif" : "image/jpeg";

            if (!conversion)
                return new ArchivoVisualizacionResult { Respuesta = false, Mensaje = "No se pudo convertir la imagen a base64." };

            return new ArchivoVisualizacionResult
            {
                Respuesta = true,
                TipoArchivo = "imagen",
                TextoBase64 = base64,
                Mime = mime
            };
        }

        /// <summary> Visualizar un video.</summary>
        public ArchivoVisualizacionResult VisualizarVideo(int idArchivo, string extension)
        {
            string rutaArchivo, mensaje;
            if (!CN_Archivo.ObtenerRutaArchivoPorId(idArchivo, out rutaArchivo, out mensaje) || string.IsNullOrEmpty(rutaArchivo))
                return new ArchivoVisualizacionResult { Respuesta = false, Mensaje = "No se pudo encontrar el video: " + mensaje };

            if (rutaArchivo.StartsWith("~"))
                rutaArchivo = rutaArchivo.Substring(1);
            rutaArchivo = rutaArchivo.Replace("\\", "/");
            if (!rutaArchivo.StartsWith("/"))
                rutaArchivo = "/" + rutaArchivo;

            string rutaFisicaArchivo = HostingEnvironment.MapPath(rutaArchivo);
            if (!File.Exists(rutaFisicaArchivo))
                return new ArchivoVisualizacionResult { Respuesta = false, Mensaje = "El video no existe en el servidor." };

            string mime = extension == ".mp4" ? "video/mp4" : extension == ".webm" ? "video/webm" : "video/ogg";
            return new ArchivoVisualizacionResult
            {
                Respuesta = true,
                TipoArchivo = "video",
                Ruta = rutaArchivo,
                Mime = mime
            };
        }

        /// <summary> Visualizar un documento Office. </summary>
        public ArchivoVisualizacionResult VisualizarDocumento(int idArchivo, string extension)
        {
            string rutaArchivo, mensaje;
            if (!CN_Archivo.ObtenerRutaArchivoPorId(idArchivo, out rutaArchivo, out mensaje) || string.IsNullOrEmpty(rutaArchivo))
                return new ArchivoVisualizacionResult { Respuesta = false, Mensaje = "No se pudo encontrar el documento: " + mensaje };

            // Normalizar la ruta del archivo
            if (rutaArchivo.StartsWith("~"))
                rutaArchivo = rutaArchivo.Substring(1);
            rutaArchivo = rutaArchivo.Replace("\\", "/");
            if (!rutaArchivo.StartsWith("/"))
                rutaArchivo = "/" + rutaArchivo;

            // Codificar la URL para manejar espacios y caracteres especiales
            string rutaArchivoCodificada = Uri.EscapeUriString(rutaArchivo);

            string mime;
            if (extension == ".pdf")
                mime = "application/pdf";
            else if (extension == ".docx" || extension == ".doc")
                mime = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
            else if (extension == ".xlsx" || extension == ".xls")
                mime = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            else if (extension == ".pptx" || extension == ".ppt")
                mime = "application/vnd.openxmlformats-officedocument.presentationml.presentation";
            else if (extension == ".txt")
                mime = "text/plain";
            else
                mime = "application/octet-stream";

            // Configuración OnlyOffice y JWT
            string nombreArchivo = System.IO.Path.GetFileName(rutaArchivo);
            string extensionArchivo = extension;
            string documentType = "word";
            if (new[] { ".xls", ".xlsx" }.Contains(extensionArchivo)) documentType = "cell";
            else if (new[] { ".ppt", ".pptx" }.Contains(extensionArchivo)) documentType = "slide";

            string uniqueKey = Uri.EscapeDataString(nombreArchivo) + "-" + DateTime.Now.Ticks;
            string baseUrl = "http://192.168.1.200"; // Cambia a tu IP si es necesario

            // Usar la ruta codificada para la URL
            string onlyofficeUrl = baseUrl + rutaArchivoCodificada;
            string callbackUrl = baseUrl + "/Archivo/OnlyOfficeCallback?idArchivo=" + idArchivo;

            var payload = new Dictionary<string, object>
            {
                { "document", new {
                    fileType = extensionArchivo.Replace(".", ""),
                    key = uniqueKey,
                    title = nombreArchivo,
                    url = onlyofficeUrl,
                    permissions = new { edit = true }
                }},
                { "editorConfig", new {
                    lang = "es",
                    mode = "edit",
                    callbackUrl = callbackUrl,
                    customization = new {
                        autosave = true,
                        forcesave = true
                    }
                }}
            };

            var generador = new GenerarOnlyOfficeToken();
            string token = generador.GenerarTokenOnlyOffice(payload);

            var onlyofficeConfig = new
            {
                width = "100%",
                height = "100%",
                type = "desktop",
                documentType = documentType,
                document = new
                {
                    fileType = extensionArchivo.Replace(".", ""),
                    key = uniqueKey,
                    title = nombreArchivo,
                    url = onlyofficeUrl,
                    permissions = new { edit = true }
                },
                editorConfig = new
                {
                    lang = "es",
                    mode = "edit",
                    callbackUrl = callbackUrl,
                    customization = new
                    {
                        autosave = true,
                        forcesave = true
                    }
                },
                token = token
            };

            return new ArchivoVisualizacionResult
            {
                Respuesta = true,
                TipoArchivo = "documento",
                Ruta = rutaArchivo,
                Mime = mime,
                ConfigOnlyOffice = onlyofficeConfig
            };
        }

        /// <summary> Visualizar un audio.</summary>
        public ArchivoVisualizacionResult VisualizarAudio(int idArchivo, string extension)
        {
            string rutaArchivo, mensaje;
            if (!CN_Archivo.ObtenerRutaArchivoPorId(idArchivo, out rutaArchivo, out mensaje) || string.IsNullOrEmpty(rutaArchivo))
                return new ArchivoVisualizacionResult { Respuesta = false, Mensaje = "No se pudo encontrar el audio: " + mensaje };

            if (rutaArchivo.StartsWith("~"))
                rutaArchivo = rutaArchivo.Substring(1);
            rutaArchivo = rutaArchivo.Replace("\\", "/");
            if (!rutaArchivo.StartsWith("/"))
                rutaArchivo = "/" + rutaArchivo;

            string mime;
            if (extension == ".mp3")
                mime = "audio/mpeg";
            else if (extension == ".wav")
                mime = "audio/wav";
            else if (extension == ".ogg")
                mime = "audio/ogg";
            else if (extension == ".aac")
                mime = "audio/aac";
            else if (extension == ".flac")
                mime = "audio/flac";
            else
                mime = "audio/mpeg";

            return new ArchivoVisualizacionResult
            {
                Respuesta = true,
                TipoArchivo = "audio",
                Ruta = rutaArchivo,
                Mime = mime
            };
        }
    }
}