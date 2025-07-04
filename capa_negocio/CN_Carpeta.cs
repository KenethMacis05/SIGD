﻿using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace capa_negocio
{
    public class CN_Carpeta
    {
        private CD_Carpeta CD_Carpeta = new CD_Carpeta();

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

        public bool CompartirCarpeta(int idCarpeta, int idUsuarioPropietario, int idUsuarioDestino, string permisos, out string mensaje)
        {
            //if (string.IsNullOrEmpty(correoDestino))
            //{
            //    mensaje = "Debe especificar un correo electrónico válido para compartir la carpeta.";
            //    return false;
            //}

            if (permisos != "lectura" && permisos != "edicion")
            {
                mensaje = "Permisos no válidos";
                return false;
            }

            return CD_Carpeta.CompartirCarpeta(idCarpeta, idUsuarioPropietario, idUsuarioDestino, permisos, out mensaje);
        }
    }
}
