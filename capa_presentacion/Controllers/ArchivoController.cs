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
        CN_Recursos CN_Recurso = new CN_Recursos();
        ArchivoService archivoService = new ArchivoService();

        #region Carpetas
        // GET: Archivo
        public ActionResult GestionArchivos()
        {
            return View();
        }

        // Controlador para Listar carpetas recientes
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

        // Controlador para Listar todas las carpetas
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

        // Controlador para Listar todas las subcarpetas
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

        // Controlador para Crear o Editar carpetas        
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

        [AllowAnonymous]
        [HttpGet]
        public ActionResult DescargarCarpeta(int idCarpeta)
        {
            string rutaCarpeta, mensaje;

            // 1. Obtener la ruta lógica de la carpeta desde la capa de negocio
            if (!CN_Carpeta.ObtenerRutaCarpetaPorId(idCarpeta, out rutaCarpeta, out mensaje) || string.IsNullOrEmpty(rutaCarpeta))
                return Content("No se pudo encontrar la carpeta: " + mensaje);

            // 2. Construir la ruta física en el servidor
            string rutaFisicaCarpeta = Server.MapPath(rutaCarpeta);

            if (!Directory.Exists(rutaFisicaCarpeta))
                return Content("La carpeta no existe en el servidor.");

            // 3. Crear archivo ZIP temporalmente
            string nombreZip = Path.GetFileName(rutaFisicaCarpeta) + ".zip";
            string tempZipPath = Path.Combine(Path.GetTempPath(), Guid.NewGuid() + ".zip");

            try
            {
                ZipFile.CreateFromDirectory(rutaFisicaCarpeta, tempZipPath);

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

        // Controlador para Eliminar una carpeta
        [HttpPost]
        public JsonResult EliminarCarpeta(int id_carpeta)
        {
            string mensaje = string.Empty;

            int resultado = CN_Carpeta.Eliminar(id_carpeta, out mensaje);

            return Json(new { Respuesta = (resultado == 1), Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        // Controlador para Eliminar Difinitivamente una carpeta o archivo
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

        // Controlador para listar archivos recientes
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

        // Controlador para listar todos los archivos
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

        // Controlador para Subir archivos
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

        [AllowAnonymous]
        [HttpPost]
        public JsonResult VisualizarArchivo(int idArchivo, string extension)
        {
            extension = extension?.ToLower();
            string[] imagenes = { ".jpg", ".jpeg", ".png", ".gif" };
            string[] videos = { ".mp4", ".webm", ".ogg" };

            if (imagenes.Contains(extension))
            {
                return VisualizarImagen(idArchivo, extension);
            }
            else if (videos.Contains(extension))
            {
                return VisualizarVideo(idArchivo, extension);
            }
            else
            {
                return Json(new { Respuesta = false, Mensaje = "Tipo de archivo no soportado." }, JsonRequestBehavior.AllowGet);
            }
        }

        // Método auxiliar para imágenes
        private JsonResult VisualizarImagen(int idArchivo, string extension)
        {
            bool conversion;
            string rutaArchivo, mensaje;

            if (!CN_Archivo.ObtenerRutaArchivoPorId(idArchivo, out rutaArchivo, out mensaje) || string.IsNullOrEmpty(rutaArchivo))
                return Json(new { Respuesta = false, Mensaje = "No se pudo encontrar la imagen: " + mensaje }, JsonRequestBehavior.AllowGet);

            string rutaFisicaArchivo = Server.MapPath(rutaArchivo);
            if (!System.IO.File.Exists(rutaFisicaArchivo))
                return Json(new { Respuesta = false, Mensaje = "La imagen no existe en el servidor." }, JsonRequestBehavior.AllowGet);

            string base64 = CN_Recurso.ConvertBase64(rutaFisicaArchivo, out conversion);
            string mime = extension == ".png" ? "image/png" : extension == ".gif" ? "image/gif" : "image/jpeg";

            if (!conversion)
                return Json(new { Respuesta = false, Mensaje = "No se pudo convertir la imagen a base64." }, JsonRequestBehavior.AllowGet);

            return Json(new
            {
                Respuesta = true,
                TipoArchivo = "imagen",
                TextoBase64 = base64,
                Mime = mime
            }, JsonRequestBehavior.AllowGet);
        }

        // Método auxiliar para videos
        private JsonResult VisualizarVideo(int idArchivo, string extension)
        {
            string rutaArchivo, mensaje;

            if (!CN_Archivo.ObtenerRutaArchivoPorId(idArchivo, out rutaArchivo, out mensaje) || string.IsNullOrEmpty(rutaArchivo))
                return Json(new { Respuesta = false, Mensaje = "No se pudo encontrar el video: " + mensaje }, JsonRequestBehavior.AllowGet);

            if (rutaArchivo.StartsWith("~"))
                rutaArchivo = rutaArchivo.Substring(1);

            rutaArchivo = rutaArchivo.Replace("\\", "/");

            if (!rutaArchivo.StartsWith("/"))
                rutaArchivo = "/" + rutaArchivo;

            string rutaFisicaArchivo = Server.MapPath(rutaArchivo);
            if (!System.IO.File.Exists(rutaFisicaArchivo))
                return Json(new { Respuesta = false, Mensaje = "El video no existe en el servidor." }, JsonRequestBehavior.AllowGet);

            string mime = extension == ".mp4" ? "video/mp4" : extension == ".webm" ? "video/webm" : "video/ogg";
            return Json(new
            {
                Respuesta = true,
                TipoArchivo = "video",
                Ruta = rutaArchivo,
                Mime = mime
            }, JsonRequestBehavior.AllowGet);
        }

        // Controlador para Eliminar una carpeta
        [HttpPost]
        public JsonResult EliminarArchivo(int id_archivo)
        {
            string mensaje = string.Empty;

            int resultado = CN_Archivo.Eliminar(id_archivo, out mensaje);

            return Json(new { Respuesta = (resultado == 1), Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }
        #endregion

        // Controlador para Listar la papelera
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

        // Controlador para Vaciar la papelera
        [HttpPost]
        public JsonResult VaciarPapelera()
        {
            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];            
            string mensaje;

            int resultado = CN_Carpeta.VaciarPapelera(usuario.id_usuario ,out mensaje);
            return Json(new { Respuesta = (resultado == 1), EsPapeleraVacia = resultado == -1, Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }
        #region ArchivosCompartidos

        // Vista a la vista de Archivos Compartidos
        public ActionResult ArchivosCompartidos()
        {
            return View();
        }

        #endregion        
    }
}