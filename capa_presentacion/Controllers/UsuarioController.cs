using capa_datos;
using capa_entidad;
using capa_negocio;
using capa_presentacion.Filters;
using capa_presentacion.Services;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Services.Description;

namespace capa_presentacion.Controllers
{
    [VerificarSession]
    public class UsuarioController : Controller
    {
        CN_Usuario CN_Usuario = new CN_Usuario();
        CN_Recursos CN_Recursos = new CN_Recursos();

        // GET: Usuario
        public ActionResult Index()
        {
            return View();
        }

        // GET: Configuraciones de usuario
        public ActionResult Configuraciones()
        {
            return View();
        }

        // Enpoint(GET): Listar los usuarios
        [HttpGet]
        public JsonResult ListarUsuarios()
        {
            List<USUARIOS> lst = new List<USUARIOS>();
            lst = CN_Usuario.Listar();

            return Json(new { data = lst }, JsonRequestBehavior.AllowGet);
        }

        // Enpoint(GET): Buscar un usuario
        [HttpGet]
        public JsonResult BuscarUsuarios(string usuario, string nombres, string apellidos)
        {
            string mensaje = string.Empty;
            List<USUARIOS> lst = CN_Usuario.BuscarUsuarios(usuario, nombres, apellidos, out mensaje);

            return Json(new { data = lst, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        // Enpoint(POST): Guardar o editar un usuario
        [HttpPost]
        public JsonResult GuardarUsuario(USUARIOS usuario)
        {
            string mensaje = string.Empty;
            int resultado = 0;
            string mensajeCarpeta = string.Empty;
            bool carpetaCreada = false;
            string usuarioGenerado = string.Empty;

            if (usuario.id_usuario == 0)
            {
                // Crear nuevo usuario y recibir el usuario generado
                resultado = CN_Usuario.Registra(usuario, out mensaje, out usuarioGenerado);

                if (resultado != 0 && !string.IsNullOrEmpty(usuarioGenerado))
                {
                    ArchivoService archivoService = new ArchivoService();
                    string carpetaRaiz = "DEFAULT_" + usuarioGenerado;
                    string rutaBaseUsuario = $@"~\ARCHIVOS\{carpetaRaiz}";

                    // Crear carpeta raíz del usuario
                    carpetaCreada = archivoService.CrearCarpeta(carpetaRaiz, out mensajeCarpeta);

                    // Crear subcarpetas dentro de la carpeta raíz del usuario
                    carpetaCreada = archivoService.CrearCarpeta("Fotos", out mensajeCarpeta, rutaBaseUsuario);
                    carpetaCreada = archivoService.CrearCarpeta("Documentos", out mensajeCarpeta, rutaBaseUsuario);
                    carpetaCreada = archivoService.CrearCarpeta("Videos", out mensajeCarpeta, rutaBaseUsuario);
                    carpetaCreada = archivoService.CrearCarpeta("Música", out mensajeCarpeta, rutaBaseUsuario);
                }
            }
            else
            {
                // Editar usuario existente
                resultado = CN_Usuario.Editar(usuario, out mensaje);
            }

            return Json(new
            {
                Resultado = resultado,
                Mensaje = mensaje,
                UsuarioGenerado = usuarioGenerado,
                CarpetaCreada = carpetaCreada,
                MensajeCarpeta = mensajeCarpeta
            }, JsonRequestBehavior.AllowGet);
        }

        // Enpoint(POST): Actualizar los datos del usuario con session activa
        [HttpPost]
        public JsonResult ActualizarDatosUsuarioAut(USUARIOS usuario)
        {
            USUARIOS usuarioAut = (USUARIOS)Session["UsuarioAutenticado"];
            if (usuarioAut == null)
            {
                return Json(new { Resultado = false, Mensaje = "Sesión no válida" });
            }

            usuario.id_usuario = usuarioAut.id_usuario;
            usuario.estado = true;

            string mensaje = string.Empty;
            int resultado = 0;         
            
            resultado = CN_Usuario.Editar(usuario, out mensaje);

            if (resultado > 0)
            {
                // Actualizar los datos en sesión
                usuarioAut.pri_nombre = usuario.pri_nombre;
                usuarioAut.seg_nombre = usuario.seg_nombre;
                usuarioAut.pri_apellido = usuario.pri_apellido;
                usuarioAut.seg_apellido = usuario.seg_apellido;
                usuarioAut.correo = usuario.correo;
                usuarioAut.telefono = usuario.telefono;
                usuarioAut.fk_rol = usuario.fk_rol;

                Session["UsuarioAutenticado"] = usuarioAut;

                return Json(new { Resultado = true, Mensaje = "Datos actualizados correctamente" });
            }

            return Json(new { Resultado = false, Mensaje = mensaje ?? "Error al actualizar los datos" });
        }

        // Enpoint(POST): Eliminar un usuario
        [HttpPost]
        public JsonResult EliminarUsuario(int id_usuario)
        {
            string mensaje = string.Empty;

            int resultado = CN_Usuario.Eliminar(id_usuario, out mensaje);

            return Json(new { Respuesta = (resultado == 1), Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        // Enpoint(POST) Reiniciar contraseña de un usuario
        [HttpPost]
        public JsonResult ReiniciarContrasena(int idUsuario)
        {
            string mensaje = string.Empty;

            int resultado = CN_Usuario.ReiniciarContrasena(idUsuario, out mensaje);

            return Json(new { Respuesta = (resultado == 1), Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        // Enpoint(POST) Actualizar contraseña
        public JsonResult ActualizarContrasena(string claveActual, string nuevaClave, string claveConfir)
        {
            USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
            int idUsuario = usuario.id_usuario;
            string mensaje = string.Empty;

            int resultado = CN_Usuario.ActualizarContrasena(idUsuario, claveActual, nuevaClave, claveConfir, out mensaje);
            return Json(new { Respuesta = (resultado == 1), Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        // Endpoint(POST): Actualizar foto de perfil del usuario autenticado
        [HttpPost]
        public JsonResult ActualizarFoto(string imagenBase64)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(imagenBase64))
                {
                    return Json(new { Respuesta = false, Mensaje = "No se recibió ninguna imagen." });
                }

                USUARIOS usuario = (USUARIOS)Session["UsuarioAutenticado"];
                int idUsuario = usuario.id_usuario;
                if (usuario == null || usuario.id_usuario != idUsuario)
                {
                    return Json(new { Respuesta = false, Mensaje = "Sesión inválida o no autorizado." });
                }

                string base64Data = imagenBase64;
                if (imagenBase64.Contains(","))
                {
                    base64Data = imagenBase64.Split(',')[1];
                }

                byte[] imageBytes;
                try
                {
                    imageBytes = Convert.FromBase64String(base64Data);
                }
                catch
                {
                    return Json(new { Respuesta = false, Mensaje = "Formato de imagen no válido." });
                }

                if (imageBytes.Length > 2 * 1024 * 1024)
                {
                    return Json(new { Respuesta = false, Mensaje = "La imagen no debe exceder los 2MB." });
                }

                string mensaje;
                bool resultado = CN_Usuario.ActualizarFotoUsuario(idUsuario, base64Data, out mensaje);

                if (resultado)
                {
                    usuario.perfil = base64Data;
                    Session["UsuarioAutenticado"] = usuario;
                }

                return Json(new { Respuesta = resultado, Mensaje = mensaje });
            }
            catch (Exception ex)
            {
                return Json(new { Respuesta = false, Mensaje = $"Error interno: {ex.Message}" });
            }
        }
    }
}