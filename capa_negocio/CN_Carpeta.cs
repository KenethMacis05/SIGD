using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace capa_negocio
{
    public class CN_Carpeta
    {
        private CD_Carpeta CD_Carpeta = new CD_Carpeta();
        private CD_Usuarios CD_Usuarios = new CD_Usuarios();

        public List<CARPETA> ListarCarpetasRecientes(int id_usuario, out int resultado, out string mensaje)
        {
            return CD_Carpeta.ListarCarpetasRecientes(id_usuario, out resultado, out mensaje);
        }

        public List<CARPETA> ListarCarpetas(int id_usuario, out int resultado, out string mensaje)
        {
            return CD_Carpeta.ListarCarpetas(id_usuario, out resultado, out mensaje);
        }

        public List<CARPETA> BuscarCarpetas(string nombre, int id_usuario, out int resultado, out string mensaje)
        {
            if (string.IsNullOrEmpty(nombre))
            {
                mensaje = "Por favor, ingrese el nombre del archivo";
            }
            return CD_Carpeta.BuscarCarpetas(nombre, id_usuario, out resultado, out mensaje);
        }
        
        public List<CARPETA> ListarSubCarpetas(int carpeta_padre, out int resultado, out string mensaje)
        {
            return CD_Carpeta.ListarSubCarpetas(carpeta_padre, out resultado, out mensaje);
        }

        public List<CARPETA> ListarCarpetasEliminadas(int id_usuario, out int resultado, out string mensaje)
        {
            return CD_Carpeta.ListarCarpetasEliminadasPorUsuario(id_usuario, out resultado, out mensaje);
        }

        public List<CARPETACOMPARTIDA> ObtenerCarpetasCompartidasPorMi(int idUsuario)
        {
            return CD_Carpeta.ObtenerCarpetasCompartidasPorMi(idUsuario);
        }

        public List<CARPETA> ListarCarpetasCompartidasConmigo(int id_usuario, out int resultado, out string mensaje)
        {
            return CD_Carpeta.ObtenerCarpetasCompartidasConmigo(id_usuario, out resultado, out mensaje);
        }

        public int Crear(CARPETA carpeta, out string mensaje)
        {
            mensaje = string.Empty;
            if (string.IsNullOrEmpty(carpeta.nombre))
            {
                mensaje = "Por favor, ingrese el nombre de la carpeta";
            }

            return CD_Carpeta.CrearCarpeta(carpeta, out mensaje);
        }

        public int Editar(CARPETA carpeta, out string mensaje)
        {
            mensaje = string.Empty;

            if (string.IsNullOrEmpty(carpeta.nombre))
            {
                mensaje = "Por favor, ingrese el nombre de la carpeta";
                return 0;
            }

            bool actualizado = CD_Carpeta.ActualizarCarpeta(carpeta, out mensaje);
            return actualizado ? 1 : 0;
        }

        public int Eliminar(int id_carpeta, out string mensaje)
        {
            bool eliminado = CD_Carpeta.EliminarCarpeta(id_carpeta, out mensaje);
            return eliminado ? 1 : 0;
        }
        
        public int EliminarDefinitivamente(int id_carpeta, out string mensaje)
        {
            bool eliminado = CD_Carpeta.EliminarCarpetaDefinitivamente(id_carpeta, out mensaje);
            return eliminado ? 1 : 0;
        }

        public int VaciarPapelera(int IdUsuario, out string mensaje)
        {
            mensaje = string.Empty;

            if (IdUsuario <= 0)
            {
                mensaje = "El ID del usuario no es válido.";
                return 0;
            }

            try
            {
                List<(string Tipo, string Ruta)> rutasAEliminar;
                bool resultado = CD_Carpeta.VaciarPapelera(IdUsuario, out mensaje, out rutasAEliminar);

                if (mensaje.Contains("no contiene registros"))
                {
                    return -1;
                }

                // Eliminar físicamente los archivos/carpetas
                if (resultado && rutasAEliminar.Any())
                {
                    var errores = new List<string>();

                    foreach (var item in rutasAEliminar)
                    {
                        try
                        {
                            string rutaFisica = HttpContext.Current.Server.MapPath(item.Ruta.Replace("~", ""));

                            if (item.Tipo == "Archivo" && System.IO.File.Exists(rutaFisica))
                            {
                                System.IO.File.Delete(rutaFisica);
                            }
                            else if (item.Tipo == "Carpeta" && System.IO.Directory.Exists(rutaFisica))
                            {
                                System.IO.Directory.Delete(rutaFisica, true);
                            }
                        }
                        catch (Exception ex)
                        {
                            errores.Add($"Error eliminando {item.Tipo}: {ex.Message}");
                        }
                    }

                    if (errores.Any())
                    {
                        mensaje += " | Errores físicos: " + string.Join("; ", errores);
                    }
                }

                return resultado ? 1 : 0;
            }
            catch (Exception ex)
            {
                mensaje = $"Error en capa de negocio: {ex.Message}";
                return 0;
            }
        }

        public bool ObtenerRutaCarpetaPorId(int idCarpeta, out string ruta, out string mensaje)
        {
            return CD_Carpeta.ObtenerRutaCarpetaPorId(idCarpeta, out ruta, out mensaje);
        }

        public int CompartirCarpeta(int idCarpeta, int idUsuarioPropietario, int idUsuarioDestino, string permisos, out string mensaje)
        {
            // Validación básica del parámetro
            if (idUsuarioDestino <= 0 || idUsuarioPropietario <= 0)
            {
                mensaje = "El identificador de usuario no es válido.";
                return 0;
            }

            // Validar que el usuario propietario no sea el mismo que el usuario destino
            if (idUsuarioPropietario == idUsuarioDestino)
            {
                mensaje = "No puedes compartir una carpeta contigo mismo.";
                return 0;
            }

            // Validar los permisos
            if (permisos != "lectura" && permisos != "edicion")
            {
                mensaje = "Permisos no válidos";
                return 0;
            }

            // Obtener usuario de destino
            USUARIOS usuarioDestino = CD_Usuarios.ObtenerUsuarioPorId(idUsuarioDestino);
            if (usuarioDestino == null)
            {
                mensaje = "El usuario seleccionado no existe.";
                return 0;
            }

            // Obtener usuario propietario
            USUARIOS usuarioPropietario = CD_Usuarios.ObtenerUsuarioPorId(idUsuarioPropietario);
            if (usuarioPropietario == null)
            {
                mensaje = "El propietario de la carpeta no existe.";
                return 0;
            }

            // Obtener carpeta por ID
            string nombreCarpeta = CD_Carpeta.ObtenerNombrePorId(idCarpeta);
            if (nombreCarpeta == null)
            {
                mensaje = "La carpeta no existe.";
                return 0;
            }

            // Validar que el usuario de destino tenga un correo electrónico
            if (string.IsNullOrWhiteSpace(usuarioDestino.correo))
            {
                mensaje = "El usuario no tiene un correo electrónico registrado.";
                return 0;
            }

            // Validar que el usuario propietario tenga un correo electrónico
            if (string.IsNullOrWhiteSpace(usuarioPropietario.correo))
            {
                mensaje = "El propietario de la carpeta no tiene un correo electrónico registrado.";
                return 0;
            }

            bool resultado = CD_Carpeta.CompartirCarpeta(idCarpeta, idUsuarioPropietario, idUsuarioDestino, permisos, out mensaje);

            if (!resultado)
            {
                mensaje = "No se pudo compartir la carpeta";
                return 0;
            }

            // Preparar el correo electrónico
            string urlBase = $"{HttpContext.Current.Request.Url.Scheme}://{HttpContext.Current.Request.Url.Authority}";
            string asunto = "Carpeta compartida - Sistema Integrado de Gestión Didáctica";
            string mensajeCorreo = $@"
                <div style='font-family: Arial, sans-serif; color: #333; line-height: 1.6;'>
                    <div style='background-color: #02116F; color: #fff; padding: 20px; text-align: center; border-radius: 10px 10px 0 0;'>
                        <h1 style='margin: 0; color: #ffffff'>Hola, {usuarioDestino.pri_nombre} {usuarioDestino.pri_apellido}</h1>
                    </div>
                    <div style='border: 1px solid #ddd; border-radius: 0 0 10px 10px; padding: 20px; background-color: #f9f9f9;'>
                        <p>
                            El usuario <strong>{usuarioPropietario.pri_nombre} {usuarioPropietario.pri_apellido}</strong> ha compartido una carpeta contigo en el Sistema Integrado de Gestión Didáctica.
                        </p>
                        <p>
                            <strong>Detalles de la carpeta compartida:</strong>
                        </p>
                        <table style='width: 100%; margin: 20px 0; border-collapse: collapse;'>
                            <tr>
                                <td style='font-weight: bold; padding: 10px; background-color: #eaf4fe; border: 1px solid #ddd;'>Nombre de la Carpeta:</td>
                                <td style='padding: 10px; border: 1px solid #ddd;'>{nombreCarpeta}</td>
                            </tr>
                            <tr>
                                <td style='font-weight: bold; padding: 10px; background-color: #eaf4fe; border: 1px solid #ddd;'>Permisos:</td>
                                <td style='padding: 10px; border: 1px solid #ddd;'>{permisos}</td>
                            </tr>
                        </table>
                        <p style='text-align: center;'>
                            Puedes acceder a esta carpeta y gestionar tus archivos iniciando sesión en el sistema.
                        </p>
                        <p style='text-align: center;'>
                            <a href='https://myfirstazurewebappasp-gee5asfwaufdawcs.canadacentral-01.azurewebsites.net' style='display: inline-block; background-color: #007BFF; color: #fff; text-decoration: none; padding: 15px 30px; border-radius: 5px; font-size: 16px;'>
                                Ir al Sistema
                            </a>
                        </p>
                        <p style='text-align: center; color: #666; font-size: 14px;'>
                            Si tienes alguna pregunta o necesitas ayuda, no dudes en contactar al administrador del sistema.
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

            bool correoEnviado = CN_Recursos.EnviarCorreo(usuarioDestino.correo, asunto, mensajeCorreo);

            if (!correoEnviado)
            {
                mensaje = "La carpeta fue compartida, pero no fue posible enviar el correo electrónico al usuario.";
                return 0;
            }

            mensaje = $"La carpeta se compartió exitosamente";
            return 1;
        }

        public int DejarDeCompartirCarpeta(int id_carpeta, int idUsuarioPropietario, out string mensaje)
        {
            bool dejarDeCompartir = CD_Carpeta.DejarDeCompartirCarpeta(id_carpeta, idUsuarioPropietario, out mensaje);
            return dejarDeCompartir ? 1 : 0;
        }
    }
}
