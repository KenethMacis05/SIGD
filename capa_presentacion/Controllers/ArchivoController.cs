using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using capa_presentacion.Filters;
using capa_negocio;
using capa_entidad;
using Newtonsoft.Json;
using System.Configuration;
using System.IO;

namespace capa_presentacion.Controllers
{
    [VerificarSession]
    public class ArchivoController : Controller
    {
        CN_Carpeta CN_Carpeta = new CN_Carpeta();
        CN_Archivo CN_Archivo = new CN_Archivo();

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
            }
            else
            {
                // Editar carpeta existente
                resultado = CN_Carpeta.Editar(carpeta, out mensaje);
            }

            return Json(new { Resultado = resultado, Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
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

        // Controlador para Subir archivos
        [HttpPost]
        public JsonResult SubirArchivo(HttpPostedFileBase ARCHIVO, string CARPETAJSON)
        {
            // Deserializar el objeto carpeta desde el JSON recibido
            CARPETA carpeta = JsonConvert.DeserializeObject<CARPETA>(CARPETAJSON);            
            string mensaje = string.Empty;

            if (ARCHIVO != null && carpeta != null)
            {
                ARCHIVO archivo = new ARCHIVO();
                string rutaGuardar = ConfigurationManager.AppSettings["ServidorArchivos"];
                string rutaFisica = Server.MapPath(rutaGuardar);
                int idCarpeta = carpeta.id_carpeta;

                // Datos del archivo recibido
                archivo.nombre = Path.GetFileName(ARCHIVO.FileName);
                archivo.tipo = Path.GetExtension(ARCHIVO.FileName);
                archivo.size = ARCHIVO.ContentLength;
                archivo.ruta = Path.Combine(rutaGuardar, archivo.nombre);
                archivo.id_usuario = (int)Session["IdUsuario"];
                archivo.id_carpeta = idCarpeta;

                if (idCarpeta == 0)
                {
                    archivo.id_carpeta = null;
                }

                // Crear la carpeta si no existe
                if (!Directory.Exists(rutaFisica))
                {
                    Directory.CreateDirectory(rutaFisica);
                }

                // Validar tamaño del archivo
                if (ARCHIVO.ContentLength > 10 * 1024 * 1024)
                {
                    mensaje = "El archivo no debe superar los 10 MB";
                    return Json(new { Respuesta = false, Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
                }

                try
                {
                    // Guardar el archivo físicamente
                    ARCHIVO.SaveAs(Path.Combine(rutaFisica, archivo.nombre));

                    // Guardar los datos del archivo en la base de datos
                    int resultado = CN_Archivo.SubirArchivo(archivo, out mensaje);

                    if (resultado == 0)
                    {
                        mensaje = "Error al guardar el archivo en la base de datos: " + mensaje;
                        return Json(new { Respuesta = false, Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
                    }

                }
                catch (Exception ex)
                {
                    mensaje = "Ocurrió un error al guardar el archivo: " + ex.Message;
                    return Json(new { Respuesta = false, Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
                }

                return Json(new { Respuesta = true, Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
            }

            mensaje = "No se seleccionó ningún archivo.";
            return Json(new { Respuesta = false, Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
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
            return Json(new { Respuesta = (resultado == 1), Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
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