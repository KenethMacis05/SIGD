using capa_datos;
using capa_entidad;
using capa_negocio;
using capa_presentacion.Filters;
using capa_presentacion.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace capa_presentacion.Controllers
{
    [VerificarSession]
    public class UsuarioController : Controller
    {
        CN_Usuario CN_Usuario = new CN_Usuario();

        // GET: Usuario
        public ActionResult Index()
        {
            return View();
        }

        //########################################################################//

        // Metodo para listar los usuarios
        [HttpGet]
        public JsonResult ListarUsuarios()
        {
            List<USUARIOS> lst = new List<USUARIOS>();
            lst = CN_Usuario.Listar();

            return Json(new { data = lst }, JsonRequestBehavior.AllowGet);
        }
        
        [HttpGet]
        public JsonResult BuscarUsuarios(string usuario, string nombres, string apellidos)
        {
            string mensaje = string.Empty;
            List<USUARIOS> lst = CN_Usuario.BuscarUsuarios(usuario, nombres, apellidos, out mensaje);

            return Json(new { data = lst, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        //########################################################################//

        // Metodo para Guardar los usuarios
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
        //########################################################################//

        // Metodo para borrar usuarios
        [HttpPost]
        public JsonResult EliminarUsuario(int id_usuario)
        {
            string mensaje = string.Empty;

            int resultado = CN_Usuario.Eliminar(id_usuario, out mensaje);

            return Json(new { Respuesta = (resultado == 1), Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        [AllowAnonymous]
        // Enpoint para reiniciar la contraseña de un usuario
        [HttpPost]
        public JsonResult RestablecerContrasena(int idUsuario)
        {
            string mensaje = string.Empty;

            int resultado = CN_Usuario.ReiniciarContrasena(idUsuario, out mensaje);

            return Json(new { Respuesta = (resultado == 1), Mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }        
    }
}