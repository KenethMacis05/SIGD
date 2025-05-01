using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using capa_datos;
using capa_entidad;
using capa_presentacion.Filters;

namespace capa_presentacion.Controllers
{
    public class AccesoController : Controller
    {
        private CD_Usuarios CD_Usuarios = new CD_Usuarios();
        // GET: Acceso  
        [HttpGet]
        public ActionResult Index(int? error)
        {
            // Verificar si existe una sesión activa
            if (Session["UsuarioAutenticado"] != null)
            {
                // Obtener el usuario autenticado de la sesión
                USUARIOS UsuarioAutenticado = (USUARIOS)Session["UsuarioAutenticado"];

                // Verificar si el usuario necesita restablecer su contraseña
                if (UsuarioAutenticado.reestablecer)
                {
                    // Redirigir a la vista de restablecer contraseña
                    return RedirectToAction("Reestablecer", "Acceso");
                }

                // Si no necesita restablecer, redirigir a la página de inicio
                return RedirectToAction("Index", "Home");
            }

            // Si no hay sesión activa, mostrar la vista de login
            return View();
        }

        [HttpGet]
        public ActionResult Reestablecer()
        {
            // Verificar si existe una sesión y el usuario está autenticado
            if (Session["UsuarioAutenticado"] == null)
            {
                TempData["ErrorMessage"] = "Sesión no válida. Por favor, inicie sesión nuevamente.";
                return RedirectToAction("Index", "Acceso");
            }

            // Verificar si el usuario ya restableció su contraseña
            USUARIOS UsuarioAutenticado = (USUARIOS)Session["UsuarioAutenticado"];
            if (!UsuarioAutenticado.reestablecer)
            {
                TempData["ErrorMessage"] = "El usuario ya ha restablecido la contraseña.";
                return RedirectToAction("Index", "Home");
            }

            // Mostrar la vista de restablecer contraseña
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Reestablecer(string passwordActual, string nuevaPassword, string confirmarPassword)
        {
            try
            {
                // Validar si hay una sesión activa
                if (Session["UsuarioAutenticado"] == null || string.IsNullOrEmpty(Session["IdUsuario"]?.ToString()))
                {
                    TempData["ErrorMessage"] = "Sesión no válida. Por favor, inicie sesión nuevamente.";
                    return RedirectToAction("Index", "Acceso");
                }

                // Obtener el usuario autenticado de la sesión
                USUARIOS UsuarioAutenticado = (USUARIOS)Session["UsuarioAutenticado"];

                // Verificar si el usuario ya restableció su contraseña
                if (!UsuarioAutenticado.reestablecer)
                {
                    TempData["ErrorMessage"] = "El usuario ya ha restablecido la contraseña.";
                    return RedirectToAction("Index", "Home");
                }

                // Validar si las contraseñas coinciden
                if (nuevaPassword != confirmarPassword)
                {
                    TempData["ErrorMessage"] = "Las contraseñas no coinciden";
                    return RedirectToAction("Reestablecer", "Acceso");
                }

                // Encriptar contraseñas
                string contrasenaActualHash = Encriptar.GetSHA256(passwordActual);
                string nuevaContraseñaHash = Encriptar.GetSHA256(nuevaPassword);

                // Llamar al método de capa de datos
                int resultado = CD_Usuarios.ReestablecerContrasena(
                    Convert.ToInt32(Session["IdUsuario"]),
                    contrasenaActualHash,
                    nuevaContraseñaHash,
                    out string mensaje
                );

                if (resultado == 1)
                {
                    // Actualizar sesión
                    var usuarioActualizado = CD_Usuarios.ObtenerUsuarioPorId(Convert.ToInt32(Session["IdUsuario"]));
                    Session["UsuarioAutenticado"] = usuarioActualizado;

                    TempData["SuccessMessage"] = "Contraseña reestablecida correctamente.";
                    return RedirectToAction("Index", "Home");
                }

                TempData["ErrorMessage"] = mensaje ?? "Error al reestablecer la contraseña.";
                return RedirectToAction("Reestablecer", "Acceso");
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "Error: " + ex.Message;
                return RedirectToAction("Reestablecer", "Acceso");
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Index(string usuario, string password)
        {
            try
            {
                string mensaje = string.Empty;
                //Generar hash de la contraseña  
                string contrasenaHash = Encriptar.GetSHA256(password);

                //Validar usuario y contraseña  
                USUARIOS usuarioAutenticado = CD_Usuarios.LoginUsuario(usuario, contrasenaHash, out mensaje);
                if (usuarioAutenticado != null)
                {
                    Session["UsuarioAutenticado"] = usuarioAutenticado;
                    Session["RolUsuario"] = usuarioAutenticado.fk_rol;
                    Session["IdUsuario"] = usuarioAutenticado.id_usuario;
                    Session.Timeout = 30;
                    if (usuarioAutenticado.reestablecer)
                    {
                        return RedirectToAction("Reestablecer", "Acceso");
                    }
                    else
                    {
                        return RedirectToAction("Index", "Home");
                    }
                }
                else
                {
                    TempData["ErrorMessage"] = mensaje ?? "Credenciales incorrectas";
                    return RedirectToAction("Index", "Acceso");
                }
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "Error al iniciar sesión: " + ex.Message;
                return RedirectToAction("Index", "Acceso");
            }
        }
    }
}