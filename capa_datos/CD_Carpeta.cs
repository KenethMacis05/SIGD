﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using capa_entidad;

namespace capa_datos
{
    public class CD_Carpeta
    {
        // Listar carpetas recientes
        public List<CARPETA> ListarCarpetasRecientes(int id_usuario, out int resultado, out string mensaje)
        {
            List<CARPETA> listaCarpeta = new List<CARPETA>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerCarpetaRecientes", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("IdUsuario", id_usuario);

                    // Parámetros de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;

                    // Abrir conexión
                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            listaCarpeta.Add(
                                new CARPETA
                                {
                                    id_carpeta = Convert.ToInt32(dr["id_carpeta"]),
                                    nombre = dr["nombre"].ToString(),
                                    ruta = dr["ruta"].ToString(),
                                    fecha_registro = Convert.ToDateTime(dr["fecha_registro"]),
                                    estado = Convert.ToBoolean(dr["estado"]),
                                    fk_id_usuario = Convert.ToInt32(dr["fk_id_usuario"]),
                                    carpeta_padre = Convert.ToInt32(dr["carpeta_padre"])
                                }
                            );
                        }
                    }

                    resultado = Convert.ToInt32(cmd.Parameters["Resultado"].Value);
                    mensaje = cmd.Parameters["Mensaje"].Value.ToString();

                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar las carpetas: " + ex.Message);
            }
            return listaCarpeta;
        }

        // Listar carpetas
        public List<CARPETA> ListarCarpetas(int id_usuario, out int resultado, out string mensaje)
        {
            List<CARPETA> listaCarpeta = new List<CARPETA>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerCarpeta", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("IdUsuario", id_usuario);

                    // Parámetros de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;

                    // Abrir conexión
                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            listaCarpeta.Add(
                                new CARPETA
                                {
                                    id_carpeta = Convert.ToInt32(dr["id_carpeta"]),
                                    nombre = dr["nombre"].ToString(),
                                    ruta = dr["ruta"].ToString(),
                                    fecha_registro = Convert.ToDateTime(dr["fecha_registro"]),
                                    estado = Convert.ToBoolean(dr["estado"]),
                                    fk_id_usuario = Convert.ToInt32(dr["fk_id_usuario"]),
                                    carpeta_padre = Convert.ToInt32(dr["carpeta_padre"])
                                }
                            );
                        }
                    }

                    resultado = Convert.ToInt32(cmd.Parameters["Resultado"].Value);
                    mensaje = cmd.Parameters["Mensaje"].Value.ToString();

                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar las carpetas: " + ex.Message);
            }
            return listaCarpeta;
        }

        public List<CARPETA> BuscarCarpetas(string nombre, int id_usuario, out int resultado, out string mensaje)
        {
            List<CARPETA> listaCarpeta = new List<CARPETA>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_BuscarCarpetasUsuario", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parametros de entrada
                    cmd.Parameters.AddWithValue("Nombre", nombre);
                    cmd.Parameters.AddWithValue("IdUsuario", id_usuario);

                    // Parámetros de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;

                    // Abrir conexión
                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            listaCarpeta.Add(
                                new CARPETA
                                {
                                    id_carpeta = Convert.ToInt32(dr["id_carpeta"]),
                                    nombre = dr["nombre"].ToString(),
                                    ruta = dr["ruta"].ToString(),
                                    fecha_registro = Convert.ToDateTime(dr["fecha_registro"]),
                                    estado = Convert.ToBoolean(dr["estado"]),
                                    fk_id_usuario = Convert.ToInt32(dr["fk_id_usuario"]),
                                    carpeta_padre = Convert.ToInt32(dr["carpeta_padre"])
                                }
                            );
                        }
                    }

                    resultado = Convert.ToInt32(cmd.Parameters["Resultado"].Value);
                    mensaje = cmd.Parameters["Mensaje"].Value.ToString();

                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar las carpetas: " + ex.Message);
            }
            return listaCarpeta;
        }

        // Listar carpetas hijas
        public List<CARPETA> ListarSubCarpetas(int carpeta_padre, out int resultado, out string mensaje)
        {
            List<CARPETA> listaSubCarpetas = new List<CARPETA>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerCarpetasHijas", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("IdCarpetaPadre", carpeta_padre);

                    // Parámetros de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;

                    // Abrir conexión
                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            listaSubCarpetas.Add(
                                new CARPETA
                                {
                                    id_carpeta = Convert.ToInt32(dr["id_carpeta"]),
                                    nombre = dr["nombre"].ToString(),
                                    ruta = dr["ruta"].ToString(),
                                    fecha_registro = Convert.ToDateTime(dr["fecha_registro"]),
                                    estado = Convert.ToBoolean(dr["estado"]),
                                    fk_id_usuario = Convert.ToInt32(dr["fk_id_usuario"]),
                                    carpeta_padre = Convert.ToInt32(dr["carpeta_padre"])
                                }
                            );
                        }
                    }

                    resultado = Convert.ToInt32(cmd.Parameters["Resultado"].Value);
                    mensaje = cmd.Parameters["Mensaje"].Value.ToString();

                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar las carpetas: " + ex.Message);
            }
            return listaSubCarpetas;
        }

        // Listar carpetas eliminadas por usuario
        public List<CARPETA> ListarCarpetasEliminadasPorUsuario(int id_usuario, out int resultado, out string mensaje)
        {
            List<CARPETA> listaCarpetaEliminada = new List<CARPETA>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_VerCarpetasEliminadasPorUsuario", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("IdUsuario", id_usuario);

                    // Parámetros de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;

                    // Abrir conexión
                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            listaCarpetaEliminada.Add(
                                new CARPETA
                                {
                                    id_carpeta = Convert.ToInt32(dr["id_carpeta"]),
                                    nombre = dr["nombre"].ToString(),
                                    ruta = dr["ruta"].ToString(),
                                    fecha_eliminacion = Convert.ToDateTime(dr["fecha_eliminacion"]),
                                    estado = Convert.ToBoolean(dr["estado"]),
                                    fk_id_usuario = Convert.ToInt32(dr["fk_id_usuario"]),
                                    carpeta_padre = dr["carpeta_padre"] == DBNull.Value ? (int?)null : Convert.ToInt32(dr["carpeta_padre"])
                                }
                            );
                        }
                    }

                    resultado = Convert.ToInt32(cmd.Parameters["Resultado"].Value);
                    mensaje = cmd.Parameters["Mensaje"].Value.ToString();
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar las carpetas eliminadas: " + ex.Message);
            }
            return listaCarpetaEliminada;
        }

        public bool ObtenerRutaCarpetaPorId(int idCarpeta, out string ruta, out string mensaje)
        {
            ruta = string.Empty;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_ObtenerRutaCarpeta", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@IdCarpeta", idCarpeta);

                    // Parámetros de salida
                    cmd.Parameters.Add("@Resultado", SqlDbType.VarChar, 255).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("@Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;

                    // Abrir conexión
                    conexion.Open();
                    cmd.ExecuteNonQuery();

                    ruta = cmd.Parameters["@Resultado"].Value?.ToString();
                    mensaje = cmd.Parameters["@Mensaje"].Value?.ToString();
                }
                return true;
            }
            catch (Exception ex)
            {
                mensaje = $"Error al consultar la ruta: {ex.Message}";
                ruta = string.Empty;
                return false;
            }
        }

        public int CrearCarpeta(CARPETA carpeta, out string mensaje)
        {
            int idAutogeneradoCarpeta = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_CrearCarpeta", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Agregar parámetros
                    cmd.Parameters.AddWithValue("Nombre", carpeta.nombre);
                    cmd.Parameters.AddWithValue("IdUsuario", carpeta.fk_id_usuario);
                                        
                    // Manejar CarpetaPadre como NULL si no está especificado
                    if (carpeta.carpeta_padre.HasValue)
                    {
                        cmd.Parameters.AddWithValue("CarpetaPadre", carpeta.carpeta_padre.Value);
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("CarpetaPadre", DBNull.Value);
                    }

                    // Parámetros de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;

                    // Abrir conexión
                    conexion.Open();

                    // Ejecutar comando
                    cmd.ExecuteNonQuery();

                    // Obtener valores de los parámetros de salida
                    idAutogeneradoCarpeta = Convert.ToInt32(cmd.Parameters["Resultado"].Value);
                    mensaje = cmd.Parameters["Mensaje"].Value.ToString();
                }
            }
            catch (Exception ex)
            {
                idAutogeneradoCarpeta = 0;
                mensaje = "Error al registrar la carpeta: " + ex.Message;
            }

            return idAutogeneradoCarpeta;
        }

        public bool ActualizarCarpeta(CARPETA carpeta, out string mensaje)
        {
            bool resultado = false;
            mensaje = string.Empty;
            try
            {
                // Crear conexión
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    // Consulta SQL con parámetros
                    SqlCommand cmd = new SqlCommand("usp_ActualizarCarpeta", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Agregar parámetros
                    cmd.Parameters.AddWithValue("IdCarpeta", carpeta.id_carpeta);
                    cmd.Parameters.AddWithValue("Nombre", carpeta.nombre);

                    // Parámetros de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Bit).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;

                    // Abrir conexión
                    conexion.Open();

                    // Ejecutar comando
                    cmd.ExecuteNonQuery();

                    // Obtener valores de los parámetros de salida
                    resultado = cmd.Parameters["Resultado"].Value != DBNull.Value && Convert.ToBoolean(cmd.Parameters["Resultado"].Value);
                    mensaje = cmd.Parameters["Mensaje"].Value != DBNull.Value ? cmd.Parameters["Mensaje"].Value.ToString() : "Mensaje no disponible.";
                }
            }
            catch (Exception ex)
            {
                resultado = false;
                mensaje = "Error al actualizar la carpeta: " + ex.Message;
            }
            return resultado;
        }

        public bool EliminarCarpeta(int id_carpeta, out string mensaje)
        {
            bool resultado = false;
            mensaje = string.Empty;
            try
            {
                // Crear conexión
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    // Consulta SQL con parámetros
                    SqlCommand cmd = new SqlCommand("usp_EliminarCarpeta", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Agregar parámetro de entrada
                    cmd.Parameters.AddWithValue("IdCarpeta", id_carpeta);

                    // Agregar parámetro de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Bit).Direction = ParameterDirection.Output;

                    // Abrir conexión
                    conexion.Open();
                    cmd.ExecuteNonQuery();

                    // Obtener valores de los parámetros de salida
                    resultado = cmd.Parameters["Resultado"].Value != DBNull.Value && Convert.ToBoolean(cmd.Parameters["Resultado"].Value);
                    mensaje = resultado ? "Carpeta eliminada correctamente" : "La carpeta no existe";
                }
            }
            catch (Exception ex)
            {
                resultado = false;
                mensaje = "Error al eliminar la carpeta: " + ex.Message;
            }
            return resultado;
        }

        public bool EliminarCarpetaDefinitivamente(int id_carpeta, out string mensaje)
        {
            bool resultado = false;
            mensaje = string.Empty;
            try
            {
                // Crear conexión
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    // Consulta SQL con parámetros
                    SqlCommand cmd = new SqlCommand("usp_EliminarCarpetaDefinitivamente", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Agregar parámetro de entrada
                    cmd.Parameters.AddWithValue("IdCarpeta", id_carpeta);

                    // Agregar parámetro de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Bit).Direction = ParameterDirection.Output;

                    // Abrir conexión
                    conexion.Open();
                    cmd.ExecuteNonQuery();

                    // Obtener valores de los parámetros de salida
                    resultado = cmd.Parameters["Resultado"].Value != DBNull.Value && Convert.ToBoolean(cmd.Parameters["Resultado"].Value);
                    mensaje = resultado ? "Carpeta eliminada correctamente" : "La carpeta no existe";
                }
            }
            catch (Exception ex)
            {
                resultado = false;
                mensaje = "Error al eliminar la carpeta: " + ex.Message;
            }
            return resultado;
        }

        public bool VaciarPapelera(int IdUsuario, out string mensaje, out List<(string Tipo, string Ruta)> rutasAEliminar)
        {
            bool resultado = false;
            mensaje = string.Empty;
            rutasAEliminar = new List<(string, string)>();

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_VaciarPapelera", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("IdUsuario", IdUsuario);
                    cmd.Parameters.Add("Resultado", SqlDbType.Bit).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.NVarChar, 500).Direction = ParameterDirection.Output;

                    conexion.Open();

                    using (var reader = cmd.ExecuteReader())
                    {
                        // Leer las rutas a eliminar
                        while (reader.Read())
                        {
                            rutasAEliminar.Add((
                                reader["Tipo"].ToString(),
                                reader["Ruta"].ToString()
                            ));
                        }

                    }

                    resultado = Convert.ToBoolean(cmd.Parameters["Resultado"].Value);
                    mensaje = cmd.Parameters["Mensaje"].Value.ToString();
                }
            }
            catch (Exception ex)
            {
                resultado = false;
                mensaje = $"Error al vaciar la papelera: {ex.Message}";
            }

            return resultado;
        }

        public bool CompartirCarpeta(int idCarpeta, int idUsuarioPropietario, int idUsuarioDestino, string permisos, out string mensaje)
        {
            bool respuesta = false;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_CompartirCarpeta", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("IdCarpeta", idCarpeta);
                    cmd.Parameters.AddWithValue("IdUsuarioPropietario", idUsuarioPropietario);
                    cmd.Parameters.AddWithValue("IdUsuarioDestino", idUsuarioDestino);
                    cmd.Parameters.AddWithValue("Permisos", permisos);

                    // Parámetros de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;

                    conexion.Open();
                    cmd.ExecuteNonQuery();

                    respuesta = Convert.ToBoolean(cmd.Parameters["Resultado"].Value);
                    mensaje = cmd.Parameters["Mensaje"].Value.ToString();
                }
            }
            catch (Exception ex)
            {
                respuesta = false;
                mensaje = "Error en la capa de datos: " + ex.Message;
            }

            return respuesta;
        }

        public List<CARPETACOMPARTIDA> ObtenerCarpetasCompartidasPorMi(int idUsuarioPropietario)
        {
            List<CARPETACOMPARTIDA> lista = new List<CARPETACOMPARTIDA>();

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_ObtenerCarpetasCompartidasPorMi", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("IdUsuarioPropietario", idUsuarioPropietario);

                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(new CARPETACOMPARTIDA
                            {
                                IdCarpeta = Convert.ToInt32(dr["id_carpeta"]),
                                NombreCarpeta = dr["nombre_carpeta"].ToString(),
                                Ruta = dr["ruta"].ToString(),
                                FechaRegistro = Convert.ToDateTime(dr["fecha_registro"]),
                                CorreoDestinatario = dr["correo_destino"].ToString(),
                                NombreDestinatario = dr["nombre_destinatario"].ToString(),
                                Permisos = dr["permisos"].ToString(),
                                FechaCompartido = Convert.ToDateTime(dr["fecha_compartido"])
                            });
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al obtener carpetas compartidas: " + ex.Message);
            }

            return lista;
        }

        public List<CARPETACOMPARTIDA> ObtenerCarpetasCompartidasConmigo(string correoUsuario)
        {
            List<CARPETACOMPARTIDA> lista = new List<CARPETACOMPARTIDA>();

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_ObtenerCarpetasCompartidasConmigo", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("CorreoUsuarioDestino", correoUsuario);

                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(new CARPETACOMPARTIDA
                            {
                                IdCarpeta = Convert.ToInt32(dr["id_carpeta"]),
                                NombreCarpeta = dr["nombre_carpeta"].ToString(),
                                Ruta = dr["ruta"].ToString(),
                                FechaRegistro = Convert.ToDateTime(dr["fecha_registro"]),
                                NombrePropietario = dr["nombre_propietario"].ToString(),
                                Permisos = dr["permisos"].ToString(),
                                FechaCompartido = Convert.ToDateTime(dr["fecha_compartido"])
                            });
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al obtener carpetas compartidas conmigo: " + ex.Message);
            }

            return lista;
        }
    }
}
