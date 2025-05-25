using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using capa_datos;
using capa_entidad;

namespace capa_negocio
{
    public class CN_Usuario
    {
        private CD_Usuarios CD_Usuarios = new CD_Usuarios();

        //Listar usuarios
        public List<USUARIOS> Listar()
        {
            return CD_Usuarios.Listar();
        }

        public List<USUARIOS> BuscarUsuarios(string usuario, string nombres, string apellidos, out string mensaje)
        {
            mensaje = string.Empty;

            if (string.IsNullOrWhiteSpace(usuario) && string.IsNullOrWhiteSpace(nombres) && string.IsNullOrWhiteSpace(apellidos))
            {
                mensaje = "Por favor, complete al menos un campo de búsqueda.";
                return new List<USUARIOS>();
            }

            return CD_Usuarios.BuscarUsuarios(usuario, nombres, apellidos, out mensaje);
        }

        public int Registra(USUARIOS usuario, out string mensaje, out string usuarioGenerado)
        {
            mensaje = string.Empty;
            usuarioGenerado = string.Empty;

            // Validación de campos obligatorios
            if (string.IsNullOrEmpty(usuario.pri_nombre) ||
                string.IsNullOrEmpty(usuario.pri_apellido) ||
                string.IsNullOrEmpty(usuario.correo))
            {
                mensaje = "Por favor, complete todos los campos obligatorios.";
                return 0;
            }

            if (usuario.fk_rol == 0)
            {
                mensaje = "Por favor, seleccione un rol.";
                return 0;
            }

            // Generación de contraseña aleatoria
            string clave = CN_Recursos.GenerarPassword();

            // Encriptar la contraseña para guardar en BD
            usuario.contrasena = CN_Recursos.EncriptarPassword(clave);

            // Llamar a la capa de datos
            int resultado = CD_Usuarios.RegistrarUsuario(usuario, out mensaje, out usuarioGenerado);

            if (resultado > 0)
            {
                // Obtener la URL base
                string urlBase = $"{HttpContext.Current.Request.Url.Scheme}://{HttpContext.Current.Request.Url.Authority}";

                // Personalización del mensaje de correo
                string asunto = "¡Bienvenido al Sistema Integrado de Gestión Didáctica!";
                string mensaje_correo = $@"
                    <div style='font-family: Arial, sans-serif; color: #333; line-height: 1.6;'>
                        <div style='background-color: #02116F; color: #fff; padding: 20px; text-align: center; border-radius: 10px 10px 0 0;'>
                            <h1 style='margin: 0; color: #ffffff'>¡Bienvenido, {usuario.pri_nombre} {usuario.pri_apellido}!</h1>
                        </div>
                        <div style='border: 1px solid #ddd; border-radius: 0 0 10px 10px; padding: 20px; background-color: #f9f9f9;'>
                            <p>
                                Nos complace informarte que tu cuenta ha sido creada exitosamente en nuestro sistema. Aquí tienes los detalles para acceder:
                            </p>
                            <table style='width: 100%; margin: 20px 0; border-collapse: collapse;'>
                                <tr>
                                    <td style='font-weight: bold; padding: 10px; background-color: #eaf4fe; border: 1px solid #ddd;'>Usuario:</td>
                                    <td style='padding: 10px; border: 1px solid #ddd;'>{usuarioGenerado}</td>
                                </tr>
                                <tr>
                                    <td style='font-weight: bold; padding: 10px; background-color: #eaf4fe; border: 1px solid #ddd;'>Contraseña:</td>
                                    <td style='padding: 10px; border: 1px solid #ddd;'>{clave}</td>
                                </tr>
                            </table>
                            <p style='text-align: center;'>
                                <a href='https://myfirstazurewebappasp-gee5asfwaufdawcs.canadacentral-01.azurewebsites.net' style='display: inline-block; background-color: #007BFF; color: #fff; text-decoration: none; padding: 15px 30px; border-radius: 5px; font-size: 16px;'>
                                    Iniciar Sesión
                                </a>
                            </p>
                            <hr style='border: none; border-top: 1px solid #ddd; margin: 40px 0;'>
                            <p style='text-align: center; font-size: 18px; font-weight: bold;'>¡Síguenos en nuestras redes sociales!</p>
                            <div style='text-align: center; margin-top: 20px;'>
                                <a href='https://www.tiktok.com/@unanmanagua' style='margin: 0 10px; text-decoration: none;'>
                                    <img src='{urlBase}/Assets/img/tiktok.png' alt='Sitio Web' style='width: 40px; height: 40px;'>
                                </a>
                                <a href='https://www.facebook.com/UNAN.Managua' style='margin: 0 10px; text-decoration: none;'>
                                    <img src='{urlBase}/Assets/img/facebook.png' alt='Facebook' style='width: 40px; height: 40px;'>
                                </a>
                                 <a href='https://x.com/UNANManagua' style='margin: 0 10px; text-decoration: none;'>
                                    <img src='{urlBase}/Assets/img/x.png' alt='Twitter' style='width: 40px; height: 40px;'>
                                </a>
                                <a href='https://www.instagram.com/unan.managua' style='margin: 0 10px; text-decoration: none;'>
                                    <img src='{urlBase}/Assets/img/instagram.png' alt='Instagram' style='width: 40px; height: 40px;'>
                                </a>
                                <a href='https://www.youtube.com/channel/UCaAtEPINZNv738R3vZI2Kjg' style='margin: 0 10px; text-decoration: none;'>
                                    <img src='{urlBase}/Assets/img/youtube.png' alt='YouTube' style='width: 40px; height: 40px;'>
                                </a>
                            </div>
                            <p style='text-align: center; margin-top: 30px; font-size: 14px; color: #666;'>
                                Gracias por unirte a nosotros,<br>
                                <strong>Sistema Integrado de Gestión Didáctica</strong>
                            </p>
                        </div>
                    </div>
                ";

                // Envío del correo
                bool correoEnviado = CN_Recursos.EnviarCorreo(usuario.correo, asunto, mensaje_correo);

                if (!correoEnviado)
                {
                    mensaje = "Ocurrió un error al enviar el correo.";
                    return 0;
                }

                return 1;
            }
            else
            {
                return 0;
            }
        }

        // Editar usuario
        public int Editar(USUARIOS usuario, out string mensaje)
        {
            mensaje = string.Empty;

            if (string.IsNullOrEmpty(usuario.pri_nombre) ||
                string.IsNullOrEmpty(usuario.pri_apellido) ||
                string.IsNullOrEmpty(usuario.usuario) ||
                string.IsNullOrEmpty(usuario.correo))
            {
                mensaje = "Por favor, complete todos los campos.";
                return 0;
            }

            if (usuario.fk_rol == 0)
            {
                mensaje = "Por favor, seleccione un rol.";
                return 0;
            }

            bool actualizado = CD_Usuarios.ActualizarUsuario(usuario, out mensaje);
            return actualizado ? 1 : 0;
        }

        //Eliminar usuario
        public int Eliminar(int id_usuario, out string mensaje)
        {
            bool eliminado = CD_Usuarios.EliminarUsuario(id_usuario, out mensaje);
            return eliminado ? 1 : 0;
        }

        // Reiniciar contraseña por usuario
        public int ReiniciarContrasena(int idUsuario, out string mensaje)
        {
            mensaje = string.Empty;

            // Validación básica del parámetro
            if (idUsuario <= 0)
            {
                mensaje = "El identificador de usuario no es válido.";
                return 0;
            }

            // Obtener usuario antes de reiniciar para validar que existe y tiene correo
            USUARIOS usuario = CD_Usuarios.ObtenerUsuarioPorId(idUsuario);
            if (usuario == null)
            {
                mensaje = "El usuario seleccionado no existe.";
                return 0;
            }
            if (string.IsNullOrWhiteSpace(usuario.correo))
            {
                mensaje = "El usuario no tiene un correo electrónico registrado.";
                return 0;
            }

            // Generar nueva contraseña y encriptarla
            string clave = CN_Recursos.GenerarPassword();
            string nuevaClave = CN_Recursos.EncriptarPassword(clave);

            // Restablecer la contraseña en la base de datos
            bool resultado = CD_Usuarios.RestablecerContrasenaPorUsuario(idUsuario, nuevaClave, out string mensajeBD);

            if (!resultado)
            {
                mensaje = mensajeBD ?? "No se pudo restablecer la contraseña. Por favor, intente nuevamente o contacte al administrador.";
                return 0;
            }

            // Preparar el correo electrónico
            string urlBase = $"{HttpContext.Current.Request.Url.Scheme}://{HttpContext.Current.Request.Url.Authority}";
            string asunto = "Restablecimiento de contraseña - Sistema Integrado de Gestión Didáctica";
            string mensajeCorreo = $@"
                <div style='font-family: Arial, sans-serif; color: #333; line-height: 1.6;'>
                    <div style='background-color: #02116F; color: #fff; padding: 20px; text-align: center; border-radius: 10px 10px 0 0;'>
                        <h1 style='margin: 0; color: #ffffff'>Hola, {usuario.pri_nombre} {usuario.pri_apellido}</h1>
                    </div>
                    <div style='border: 1px solid #ddd; border-radius: 0 0 10px 10px; padding: 20px; background-color: #f9f9f9;'>
                        <p>
                            Se ha restablecido tu contraseña en el Sistema Integrado de Gestión Didáctica. 
                            A continuación encontrarás tus nuevas credenciales de acceso:
                        </p>
                        <table style='width: 100%; margin: 20px 0; border-collapse: collapse;'>
                            <tr>
                                <td style='font-weight: bold; padding: 10px; background-color: #eaf4fe; border: 1px solid #ddd;'>Usuario:</td>
                                <td style='padding: 10px; border: 1px solid #ddd;'>{usuario.usuario}</td>
                            </tr>
                            <tr>
                                <td style='font-weight: bold; padding: 10px; background-color: #eaf4fe; border: 1px solid #ddd;'>Contraseña temporal:</td>
                                <td style='padding: 10px; border: 1px solid #ddd;'>{clave}</td>
                            </tr>
                        </table>
                        <p style='text-align: center;'>
                            <a href='https://myfirstazurewebappasp-gee5asfwaufdawcs.canadacentral-01.azurewebsites.net' style='display: inline-block; background-color: #007BFF; color: #fff; text-decoration: none; padding: 15px 30px; border-radius: 5px; font-size: 16px;'>
                                Iniciar Sesión
                            </a>
                        </p>
                        <p style='margin-top: 30px; color: #666; font-size: 14px;'>
                            Por seguridad, te recomendamos cambiar tu contraseña después de iniciar sesión.<br>
                            Si no solicitaste este restablecimiento, por favor contacta al administrador del sistema.
                        </p>
                        <hr style='border: none; border-top: 1px solid #ddd; margin: 40px 0;'>
                        <p style='text-align: center; font-size: 18px; font-weight: bold;'>Síguenos en nuestras redes sociales</p>
                        <div style='text-align: center; margin-top: 20px;'>
                            <a href='https://www.tiktok.com/@unanmanagua' style='margin: 0 10px; text-decoration: none;'>
                                <img src='{urlBase}/Assets/img/tiktok.png' alt='TikTok' style='width: 40px; height: 40px;'>
                            </a>
                            <a href='https://www.facebook.com/UNAN.Managua' style='margin: 0 10px; text-decoration: none;'>
                                <img src='{urlBase}/Assets/img/facebook.png' alt='Facebook' style='width: 40px; height: 40px;'>
                            </a>
                            <a href='https://x.com/UNANManagua' style='margin: 0 10px; text-decoration: none;'>
                                <img src='{urlBase}/Assets/img/x.png' alt='Twitter' style='width: 40px; height: 40px;'>
                            </a>
                            <a href='https://www.instagram.com/unan.managua' style='margin: 0 10px; text-decoration: none;'>
                                <img src='{urlBase}/Assets/img/instagram.png' alt='Instagram' style='width: 40px; height: 40px;'>
                            </a>
                            <a href='https://www.youtube.com/channel/UCaAtEPINZNv738R3vZI2Kjg' style='margin: 0 10px; text-decoration: none;'>
                                <img src='{urlBase}/Assets/img/youtube.png' alt='YouTube' style='width: 40px; height: 40px;'>
                            </a>
                        </div>
                        <p style='text-align: center; margin-top: 30px; font-size: 14px; color: #666;'>
                            Atentamente,<br>
                            <strong>Equipo de soporte - Sistema Integrado de Gestión Didáctica</strong>
                        </p>
                    </div>
                </div>
            ";

            bool correoEnviado = CN_Recursos.EnviarCorreo(usuario.correo, asunto, mensajeCorreo);

            if (!correoEnviado)
            {
                mensaje = "La contraseña ha sido restablecida, pero no fue posible enviar el correo electrónico al usuario.";
                return 0;
            }

            mensaje = $"La contraseña del usuario <b>{usuario.pri_nombre} {usuario.pri_apellido}</b> se restableció correctamente y se envió un correo con las nuevas credenciales.";
            return 1;
        }
    }
}