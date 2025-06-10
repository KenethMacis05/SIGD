using capa_datos;
using capa_entidad;
using capa_negocio;
using capa_presentacion.Filters;
using capa_presentacion.Services;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Services.Description;

namespace capa_presentacion.Controllers
{
    [VerificarSession]
    public class ArchivoController : Controller
    {
        CN_Carpeta CN_Carpeta = new CN_Carpeta();
        CN_Archivo CN_Archivo = new CN_Archivo();
        ArchivoService archivoService = new ArchivoService();

        #region Carpetas
        // GET: Archivo
        public ActionResult GestionArchivos()
        {
            return View();
        }

        // Enpoint(GET): Listar carpetas recientes        
        [HttpGet]
        public JsonResult ListarCarpetasRecientes()
        {
            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
            int resultado;
            string mensaje;

            List<CARPETA> lst = new List<CARPETA>();
            lst = CN_Carpeta.ListarCarpetasRecientes(usuario.id_usuario, out resultado, out mensaje);

            return Json(new { data = lst, resultado = resultado, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        // Enpoint(GET): Listar todas las carpetas del usuario autenticado
        [HttpGet]
        public JsonResult ListarCarpetas()
        {
            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
            int resultado;
            string mensaje;

            List<CARPETA> lst = new List<CARPETA>();
            lst = CN_Carpeta.ListarCarpetas(usuario.id_usuario, out resultado, out mensaje);

            return Json(new { data = lst, resultado = resultado, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }
        
        // Enpoint(POST): Listar carpetas por ID de carpeta padre
        [HttpPost]
        public JsonResult ListarSubCarpetas(int idCarpeta)
        {            
            int resultado;
            string mensaje;

            if (idCarpeta <= 0)
            {
                return Json(new { data = new List<CARPETA>(), resultado = 0, mensaje = "El ID de la carpeta no es válido" }, JsonRequestBehavior.AllowGet);
            }

            try
            {
                List<CARPETA> lst = CN_Carpeta.ListarSubCarpetas(idCarpeta, out resultado, out mensaje);
                return Json(new { data = lst, resultado = resultado, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { data = new List<CARPETA>(), resultado = -1, mensaje = "Error interno: " + ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
        
        // Enpoint(POST): Crear o Editar carpeta
        [HttpPost]
        public JsonResult GuardarCarpeta(CARPETA carpeta)
        {
            carpeta.fk_id_usuario = (int)Session["IdUsuario"];            
            string mensaje = string.Empty;
            int resultado = 0;

            if (carpeta.carpeta_padre == 0)
            {
                carpeta.carpeta_padre = null;
            }

            if (carpeta.id_carpeta == 0)
            {
                // Crear nueva carpeta
                resultado = CN_Carpeta.Crear(carpeta, out mensaje);
                if (resultado > 0)
                {
                    string mensajeCarpeta = string.Empty;
                    string mensajeRuta = string.Empty;
                    string rutaReal = string.Empty;

                    bool rutaObtenida = CN_Carpeta.ObtenerRutaCarpetaPorId(resultado, out rutaReal, out mensajeRuta);

                    if (rutaObtenida && !string.IsNullOrEmpty(rutaReal))
                    {
                        bool carpetaCreada = archivoService.CrearCarpeta("", out mensajeCarpeta, rutaReal);
                    }
                    else
                    {
                        mensaje = "Error al obtener la ruta física: " + mensajeRuta;
                    }
                }
            }
            else
            {
                // Editar carpeta existente
                resultado = CN_Carpeta.Editar(carpeta, out mensaje);
            }

            return Json(new { Resultado = resultado, Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }
        
        // Epoint(POST): Eliminar una carpeta
        [HttpPost]
        public JsonResult EliminarCarpeta(int id_carpeta)
        {
            string mensaje = string.Empty;

            int resultado = CN_Carpeta.Eliminar(id_carpeta, out mensaje);

            return Json(new { Respuesta = (resultado == 1), Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        // Epoint(POST): Eliminar una carpeta o archivo de forma definitiva
        [HttpPost]
        public JsonResult EliminarDefinitivamente(int id_eliminar, string tipo_registro)
        {
            string mensaje = string.Empty;
            int resultado = 0;

            // Validar parámetros
            if (id_eliminar <= 0 || string.IsNullOrEmpty(tipo_registro) || (tipo_registro != "Carpeta" && tipo_registro != "Archivo"))
            {
                return Json(new { Respuesta = false, Mensaje = "Parámetros inválidos." }, JsonRequestBehavior.AllowGet);
            }

            if (tipo_registro == "Carpeta")
            {             
                resultado = CN_Carpeta.EliminarDefinitivamente(id_eliminar, out mensaje);
            }
            else
            {
                resultado = CN_Archivo.EliminarDefinitivamente(id_eliminar, out mensaje);
            }

            return Json(new { Respuesta = (resultado == 1), Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region CarpetasCompartidas

        // Vista a la vista de Carpetas Compartidas
        public ActionResult CarpetasCompartidas()
        {
            return View();
        }

        // Controlador para Listar las carpetas compartidas

        // Controlador para Guardar carpetas compartidas

        // Controlador para Borrar carpetas compartidas

        // Controlador para Listar carpetas recientes                

        #endregion

        #region Archivos      

        // Endpoint(GET): para listar archivos recientes del usuario autenticado
        [HttpGet]
        public JsonResult ListarArchivosRecientes()
        {
            try
            {
                USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
                int resultado;
                string mensaje;                

                List<ARCHIVO> lst = new List<ARCHIVO>();
                lst = CN_Archivo.ListarArchivosRecientes(usuario.id_usuario, out resultado, out mensaje);

                return Json(new { data = lst, resultado = resultado, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { resultado = 0, mensaje = "Error al obtener los archivos recientes: " + ex.Message, data = new List<ARCHIVO>() }, JsonRequestBehavior.AllowGet);
            }
        }

        // Endpoint(GET): para listar todos los archivos del usuario autenticado
        [HttpGet]
        public JsonResult ListarArchivos()
        {
            try
            {
                USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
                int resultado;
                string mensaje;

                List<ARCHIVO> lst = new List<ARCHIVO>();
                lst = CN_Archivo.ListarArchivos(usuario.id_usuario, out resultado, out mensaje);

                return Json(new { data = lst, resultado = resultado, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { resultado = 0, mensaje = "Error al obtener los archivos recientes: " + ex.Message, data = new List<ARCHIVO>() }, JsonRequestBehavior.AllowGet);
            }
        }

        // Endpoint(GET): para listar archivos por carpeta
        [HttpGet]
        public JsonResult ListarArchivosPorCarpeta(int idCarpeta)
        {
            try
            {                
                int resultado;
                string mensaje;

                List<ARCHIVO> lst = new List<ARCHIVO>();
                lst = CN_Archivo.ListarArchivosPorCarpeta(idCarpeta, out resultado, out mensaje);

                return Json(new { data = lst, resultado = resultado, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { resultado = 0, mensaje = "Error al obtener los archivos: " + ex.Message, data = new List<ARCHIVO>() }, JsonRequestBehavior.AllowGet);
            }
        }

        // Endpoint(POST): para subir un archivo a una carpeta específica
        [HttpPost]
        public JsonResult SubirArchivo(HttpPostedFileBase ARCHIVO, string CARPETAJSON)
        {
            if (ARCHIVO == null || string.IsNullOrEmpty(CARPETAJSON))
                return Json(new { Respuesta = false, Mensaje = "No se seleccionó ningún archivo o carpeta." });

            CARPETA carpeta = JsonConvert.DeserializeObject<CARPETA>(CARPETAJSON);
            int idCarpeta = carpeta.id_carpeta;

            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
            if (usuario == null)
                return Json(new { Respuesta = false, Mensaje = "Sesión expirada, vuelva a iniciar sesión." });

            ArchivoService archivoService = new ArchivoService();
            string mensaje;    
            bool ok = archivoService.SubirArchivoConCarpeta(ARCHIVO, idCarpeta, usuario.id_usuario, out mensaje);

            return Json(new { Respuesta = ok, Mensaje = mensaje });
        }

        // Endpoint(POST): para eliminar un archivo
        [HttpPost]
        public JsonResult EliminarArchivo(int id_archivo)
        {
            string mensaje = string.Empty;

            int resultado = CN_Archivo.Eliminar(id_archivo, out mensaje);

            return Json(new { Respuesta = (resultado == 1), Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }
        #endregion
        
        #region ArchivosCompartidos

        // Vista a la vista de Archivos Compartidos
        public ActionResult ArchivosCompartidos()
        {
            return View();
        }

        #endregion

        #region Papelera

        // Endpoint(GET): para listar archivos y carpetas eliminados del usuario autenticado (Papelera)
        [HttpGet]
        public JsonResult ListarPapelera()
        {
            try
            {
                // Obtener el usuario autenticado desde la sesión
                USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];

                if (usuario == null)
                {
                    return Json(new { resultado = 0, mensaje = "El usuario no está autenticado.", data = new { archivos = new List<ARCHIVO>(), carpetas = new List<CARPETA>() } }, JsonRequestBehavior.AllowGet);
                }

                int resultadoArchivos, resultadoCarpetas;
                string mensajeArchivos, mensajeCarpetas;

                // Obtener archivos eliminados
                List<ARCHIVO> archivosEliminados = CN_Archivo.ListarArchivosElimandos(usuario.id_usuario, out resultadoArchivos, out mensajeArchivos);

                // Obtener carpetas eliminadas
                List<CARPETA> carpetasEliminadas = CN_Carpeta.ListarCarpetasEliminadas(usuario.id_usuario, out resultadoCarpetas, out mensajeCarpetas);

                // Verificar los resultados de ambos métodos
                if (resultadoArchivos == 0 && resultadoCarpetas == 0)
                {
                    return Json(new { resultado = 0, mensaje = "No se encontraron archivos ni carpetas eliminados para el usuario.", data = new { archivos = archivosEliminados, carpetas = carpetasEliminadas } }, JsonRequestBehavior.AllowGet);
                }

                // Combinar mensajes si ambos tienen éxito
                string mensaje = $"Archivos: {mensajeArchivos}. Carpetas: {mensajeCarpetas}.";

                return Json(new { resultado = 1, mensaje = mensaje, data = new { archivos = archivosEliminados, carpetas = carpetasEliminadas } }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { resultado = 0, mensaje = "Error al obtener archivos y carpetas eliminados: " + ex.Message, data = new { archivos = new List<ARCHIVO>(), carpetas = new List<CARPETA>() } }, JsonRequestBehavior.AllowGet);
            }
        }

        // Endpoint(POST): para vaciar la papelera del usuario autenticado
        [HttpPost]
        public JsonResult VaciarPapelera()
        {
            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
            string mensaje;

            int resultado = CN_Carpeta.VaciarPapelera(usuario.id_usuario, out mensaje);
            return Json(new { Respuesta = (resultado == 1), EsPapeleraVacia = resultado == -1, Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        #endregion        

        // Controlador para Descargar una carpeta como ZIP
        [AllowAnonymous]
        [HttpGet]
        public ActionResult DescargarCarpeta(int idCarpeta)
        {
            string rutaCarpeta, mensaje;
            string nombreZip;
            string rutaFisicaCarpeta;

            // Caso especial para idCarpeta = 0 (carpeta DEFAULT del usuario)
            if (idCarpeta == 0)
            {
                USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
                if (usuario == null)
                    return Content("No se pudo identificar al usuario. Sesión no disponible.");

                // Obtener la ruta base de archivos desde web.config
                string rutaBaseArchivos = ConfigurationManager.AppSettings["ServidorArchivos"];
                if (string.IsNullOrEmpty(rutaBaseArchivos))
                    return Content("Configuración del servidor de archivos no encontrada.");

                // Construir la ruta física correcta
                rutaCarpeta = $"DEFAULT_{usuario.usuario}";
                rutaFisicaCarpeta = Path.Combine(Server.MapPath(rutaBaseArchivos), rutaCarpeta);
                nombreZip = $"{usuario.usuario}.zip";
            }
            else
            {
                // 1. Obtener la ruta lógica de la carpeta desde la capa de negocio
                if (!CN_Carpeta.ObtenerRutaCarpetaPorId(idCarpeta, out rutaCarpeta, out mensaje) || string.IsNullOrEmpty(rutaCarpeta))
                    return Content("No se pudo encontrar la carpeta: " + mensaje);

                // 2. Construir la ruta física en el servidor
                rutaFisicaCarpeta = Server.MapPath(rutaCarpeta);
                nombreZip = Path.GetFileName(rutaFisicaCarpeta) + ".zip";
            }

            if (!Directory.Exists(rutaFisicaCarpeta))
                return Content("La carpeta no existe en el servidor.");

            // 3. Crear archivo ZIP temporalmente
            string tempZipPath = Path.Combine(Path.GetTempPath(), Guid.NewGuid() + ".zip");

            try
            {
                ZipFile.CreateFromDirectory(rutaFisicaCarpeta, tempZipPath, CompressionLevel.Fastest, false);

                byte[] bytesArchivo = System.IO.File.ReadAllBytes(tempZipPath);

                // Borra el archivo temporal después de leerlo
                System.IO.File.Delete(tempZipPath);

                return File(bytesArchivo, "application/zip", nombreZip);
            }
            catch (Exception ex)
            {
                // Borra el ZIP si existió pero falló la descarga
                if (System.IO.File.Exists(tempZipPath))
                    System.IO.File.Delete(tempZipPath);

                return Content("Ocurrió un error al comprimir la carpeta: " + ex.Message);
            }
        }

        // Controlador para Descargar un archivo
        [AllowAnonymous]
        [HttpGet]
        public ActionResult DescargarArchivo(int idArchivo)
        {
            string rutaArchivo, mensaje;

            // 1. Obtener la ruta lógica del archivo desde la capa de negocio
            if (!CN_Archivo.ObtenerRutaArchivoPorId(idArchivo, out rutaArchivo, out mensaje) || string.IsNullOrEmpty(rutaArchivo))
                return Content("No se pudo encontrar el archivo: " + mensaje);

            // 2. Construir la ruta física en el servidor
            string rutaFisicaArchivo = Server.MapPath(rutaArchivo);

            if (!System.IO.File.Exists(rutaFisicaArchivo))
                return Content("El archivo no existe en el servidor.");

            try
            {
                // 3. Leer el archivo y devolverlo
                byte[] bytesArchivo = System.IO.File.ReadAllBytes(rutaFisicaArchivo);
                string nombreArchivo = Path.GetFileName(rutaFisicaArchivo);

                // Opcional: Detectar el tipo MIME
                string mimeType = MimeMapping.GetMimeMapping(nombreArchivo);

                return File(bytesArchivo, mimeType, nombreArchivo);
            }
            catch (Exception ex)
            {
                return Content("Ocurrió un error al descargar el archivo: " + ex.Message);
            }
        }

        // Controlador para visualizar un archivo (imagen, video, documento, audio)
        [AllowAnonymous]
        [HttpPost]
        public JsonResult VisualizarArchivo(int idArchivo, string extension)
        {
            extension = extension?.ToLower();
            string[] imagenes = { ".jpg", ".jpeg", ".png", ".gif" };
            string[] videos = { ".mp4", ".webm", ".ogg" };
            string[] docs = { ".pdf", ".docx", ".doc", ".xlsx", ".xls", ".pptx", ".ppt", ".txt" };
            string[] audios = { ".mp3", ".wav", ".ogg", ".aac", ".flac" };

            var archivoService = new ArchivoService();
            ArchivoVisualizacionResult result;

            if (imagenes.Contains(extension))
                result = archivoService.VisualizarImagen(idArchivo, extension);
            else if (videos.Contains(extension))
                result = archivoService.VisualizarVideo(idArchivo, extension);
            else if (docs.Contains(extension))
                result = archivoService.VisualizarDocumento(idArchivo, extension);
            else if (audios.Contains(extension))
                result = archivoService.VisualizarAudio(idArchivo, extension);
            else
                result = new ArchivoVisualizacionResult { Respuesta = false, Mensaje = "Tipo de archivo no soportado." };

            return Json(result, JsonRequestBehavior.AllowGet);
        }

        // Enpoint(POST): Resivir el Callback enviado por OnlyOffice
        [AllowAnonymous]
        [HttpPost]
        public ActionResult OnlyOfficeCallback(int idArchivo)
        {
            string logPath = Server.MapPath("~/App_Data/onlyoffice_callback_debug.log");
            string errorPath = Server.MapPath("~/App_Data/onlyoffice_callback_errors.log");

            try
            {
                // Leer el JSON directamente
                Request.InputStream.Position = 0;
                string jsonBody = new StreamReader(Request.InputStream).ReadToEnd();
                dynamic data = Newtonsoft.Json.JsonConvert.DeserializeObject(jsonBody);

                // Log detallado
                System.IO.File.AppendAllText(logPath, $"{DateTime.Now:u} - ---- NUEVO REQUEST ----\n");
                System.IO.File.AppendAllText(logPath, $"Content-Type: {Request.ContentType}\n");
                System.IO.File.AppendAllText(logPath, $"JSON recibido:\n{jsonBody}\n");

                // Extraer valores del JSON
                int status = data?.status ?? 0;
                string url = data?.url?.ToString();

                if ((status == 2 || status == 6) && !string.IsNullOrEmpty(url))
                {
                    string rutaArchivo, mensaje;
                    if (CN_Archivo.ObtenerRutaArchivoPorId(idArchivo, out rutaArchivo, out mensaje) && !string.IsNullOrEmpty(rutaArchivo))
                    {
                        string pathFisico = Server.MapPath(rutaArchivo);

                        System.IO.File.AppendAllText(logPath, $"{DateTime.Now:u} - Procesando:\n");
                        System.IO.File.AppendAllText(logPath, $"ID Archivo: {idArchivo}\n");
                        System.IO.File.AppendAllText(logPath, $"Ruta destino: {pathFisico}\n");

                        // Descargar archivo
                        using (var wc = new System.Net.WebClient())
                        {
                            wc.DownloadFile(url, pathFisico);
                            System.IO.File.AppendAllText(logPath, $"{DateTime.Now:u} - Archivo guardado exitosamente\n");
                        }
                    }
                    else
                    {
                        System.IO.File.AppendAllText(errorPath, $"{DateTime.Now:u} - Archivo no encontrado (ID: {idArchivo})\n");
                        return Json(new { error = 4, mensaje = "Archivo no encontrado" });
                    }
                }
                else
                {
                    System.IO.File.AppendAllText(logPath, $"{DateTime.Now:u} - No requiere acción (Status: {status}, URL: {url ?? "null"})\n");
                }

                return Json(new { error = 0 });
            }
            catch (Exception ex)
            {
                System.IO.File.AppendAllText(errorPath, $"{DateTime.Now:u} - ERROR: {ex}\n");
                return Json(new { error = 1, mensaje = "Error al conectarse con el servidor" });
            }
        }
    }
}