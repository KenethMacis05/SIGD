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
    public class CN_MatrizAsignatura
    {
        CD_MatrizAsignatura CD_MatrizAsignatura = new CD_MatrizAsignatura();
        CD_Usuarios CD_Usuario = new CD_Usuarios();
        CD_Asignatura CD_Asignatura = new CD_Asignatura();
        CD_MatrizIntegracionComponentes CD_MatrizIntegracion = new CD_MatrizIntegracionComponentes();

        public List<MATRIZASIGNATURA> ListarAsignaturasPorMatriz(int fk_matriz_integracion, out int resultado, out string mensaje)
        {
            return CD_MatrizAsignatura.ListarAsignaturasPorMatriz(fk_matriz_integracion, out resultado, out mensaje);
        }

        public int Asignar(MATRIZASIGNATURA matriz, out string mensaje)
        {
            mensaje = string.Empty;

            // Validaciones básicas
            if (matriz == null)
            {
                mensaje = "Los datos de la asignatura no pueden ser nulos";
                return 0;
            }

            if (matriz.fk_matriz_integracion <= 0)
            {
                mensaje = "Debe especificar una matriz de integración válida";
                return 0;
            }

            if (matriz.fk_asignatura <= 0)
            {
                mensaje = "Debe seleccionar una asignatura válida";
                return 0;
            }

            if (matriz.fk_profesor_asignado <= 0)
            {
                mensaje = "Debe seleccionar un profesor válido";
                return 0;
            }

            // Llamar al método de la capa de datos
            int resultado = CD_MatrizAsignatura.AsignarAsignaturaMatriz(matriz, out mensaje);

            if (resultado > 0)
            {
                try
                {
                    // Obtener información del profesor asignado
                    USUARIOS usuario = CD_Usuario.ObtenerUsuarioPorId(matriz.fk_profesor_asignado);

                    // Obtener información de la asignatura
                    ASIGNATURA asignatura = CD_Asignatura.ObtenerAsignaturaPorId(matriz.fk_asignatura);

                    // Obtener información de la matriz
                    MATRIZINTEGRACIONCOMPONENTES matrizInfo = CD_MatrizIntegracion.ObtenerMatrizPorId(matriz.fk_matriz_integracion, matriz.fk_profesor_propietario);

                    if (usuario != null && !string.IsNullOrEmpty(usuario.correo))
                    {
                        // Obtener la URL base
                        string urlBase = $"{HttpContext.Current.Request.Url.Scheme}://{HttpContext.Current.Request.Url.Authority}";

                        // Personalización del mensaje de correo para asignación de asignatura
                        string asunto = "Nueva Asignación de Asignatura - Sistema de Gestión Didáctica";
                        string mensaje_correo = $@"
                            <div style='font-family: Arial, sans-serif; color: #333; line-height: 1.6;'>
                                <div style='background-color: #0072BB; color: #fff; padding: 20px; text-align: center; border-radius: 10px 10px 0 0;'>
                                    <h1 style='margin: 0; color: #ffffff'>¡Nueva Asignación de Asignatura!</h1>
                                </div>
                                <div style='border: 1px solid #ddd; border-radius: 0 0 10px 10px; padding: 20px; background-color: #f9f9f9;'>
                                    <p>Estimado/a <strong>{usuario.pri_nombre} {usuario.pri_apellido}</strong>,</p>
                            
                                    <p>Se le ha asignado una nueva asignatura en el Sistema de Gestión Didáctica:</p>
                            
                                    <table style='width: 100%; margin: 20px 0; border-collapse: collapse;'>
                                        <tr>
                                            <td style='font-weight: bold; padding: 10px; background-color: #eaf4fe; border: 1px solid #ddd;'>Asignatura:</td>
                                            <td style='padding: 10px; border: 1px solid #ddd;'>{asignatura?.nombre ?? "N/A"}</td>
                                        </tr>
                                        <tr>
                                            <td style='font-weight: bold; padding: 10px; background-color: #eaf4fe; border: 1px solid #ddd;'>Matriz de Integración:</td>
                                            <td style='padding: 10px; border: 1px solid #ddd;'>{matrizInfo?.nombre ?? "N/A"}</td>
                                        </tr>
                                        <tr>
                                            <td style='font-weight: bold; padding: 10px; background-color: #eaf4fe; border: 1px solid #ddd;'>Código Matriz:</td>
                                            <td style='padding: 10px; border: 1px solid #ddd;'>{matrizInfo?.codigo ?? "N/A"}</td>
                                        </tr>
                                        <tr>
                                            <td style='font-weight: bold; padding: 10px; background-color: #eaf4fe; border: 1px solid #ddd;'>Estado:</td>
                                            <td style='padding: 10px; border: 1px solid #ddd;'>Iniciado</td>
                                        </tr>
                                    </table>
                            
                                    <p>Por favor, acceda al sistema para comenzar a trabajar en la descripción de la asignatura y definir la acción integradora.</p>
                            
                                    <p style='text-align: center;'>
                                        <a href='{urlBase}' style='display: inline-block; background-color: #0072BB; color: #fff; text-decoration: none; padding: 15px 30px; border-radius: 5px; font-size: 16px;'>
                                            Acceder al Sistema
                                        </a>
                                    </p>
                            
                                    <hr style='border: none; border-top: 1px solid #ddd; margin: 40px 0;'>
                            
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
                                        <strong>Sistema Integrado de Gestión Didáctica</strong><br>
                                        UNAN Managua
                                    </p>
                                </div>
                            </div>
                        ";

                        // Envío del correo
                        bool correoEnviado = CN_Recursos.EnviarCorreo(usuario.correo, asunto, mensaje_correo);

                        if (!correoEnviado)
                        {
                            // Si falla el correo, no afectamos la operación principal pero lo registramos
                            mensaje += " | Asignación completada, pero no se pudo enviar la notificación por correo.";
                        }
                        else
                        {
                            mensaje += " | Notificación enviada al docente asignado.";
                        }
                    }
                }
                catch (Exception ex)
                {
                    // Si hay error en el envío de correo, no afectamos la operación principal
                    mensaje += " | Asignación completada, pero error al enviar notificación: " + ex.Message;
                }

                return resultado;
            }

            return resultado;
        }

        public int Actualizar(MATRIZASIGNATURA matriz, out string mensaje)
        {
            mensaje = string.Empty;

            // Validaciones básicas
            if (matriz == null)
            {
                mensaje = "Los datos de la asignatura no pueden ser nulos";
                return 0;
            }

            if (matriz.id_matriz_asignatura <= 0)
            {
                mensaje = "Debe especificar una asignatura de matriz válida";
                return 0;
            }

            // Verificar que al menos un campo sea proporcionado para actualizar
            if (matriz.fk_asignatura <= 0 && matriz.fk_profesor_asignado <= 0)
            {
                mensaje = "Debe proporcionar al menos una asignatura o profesor para actualizar";
                return 0;
            }

            // Llamar al método de la capa de datos
            return CD_MatrizAsignatura.ActualizarMatrizAsignatura(matriz, out mensaje);
        }

        public int Eliminar(int id_matriz_asignatura, int fk_profesor_propietario, out string mensaje)
        {
            bool eliminado = CD_MatrizAsignatura.Eliminar(id_matriz_asignatura, fk_profesor_propietario, out mensaje);
            return eliminado ? 1 : 0;
        }

        public MATRIZASIGNATURA ObtenerAsignaturaDelaMatrizPorId(int id)
        {
            return CD_MatrizAsignatura.ObtenerAsignaturaPorId(id);
        }
    }
}