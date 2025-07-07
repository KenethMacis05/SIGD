using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using capa_entidad;

namespace capa_datos
{
    public class CD_Archivo
    {
        public List<ARCHIVO> ListarArchivosRecientes(int id_usuario, out int resultado, out string mensaje)
        {
            List<ARCHIVO> listaArchivo = new List<ARCHIVO>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerArchivosDelaCarpetaRaizRecientes", conexion);
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
                            listaArchivo.Add(
                                new ARCHIVO
                                {
                                    id_archivo = dr["id_archivo"] != DBNull.Value ? Convert.ToInt32(dr["id_archivo"]) : 0,
                                    nombre = dr["nombre_archivo"] != DBNull.Value ? dr["nombre_archivo"].ToString() : string.Empty,
                                    ruta = dr["ruta"] != DBNull.Value ? dr["ruta"].ToString() : string.Empty,
                                    size = dr["size"] != DBNull.Value ? Convert.ToInt32(dr["size"]) : 0,
                                    tipo = dr["tipo"] != DBNull.Value ? dr["tipo"].ToString() : string.Empty,
                                    estado = dr["estado"] != DBNull.Value && Convert.ToBoolean(dr["estado"]),
                                    id_carpeta = dr["fk_id_carpeta"] != DBNull.Value ? Convert.ToInt32(dr["fk_id_carpeta"]) : 0,
                                    nombre_carpeta = dr["nombre_carpeta"] != DBNull.Value ? dr["nombre_carpeta"].ToString() : string.Empty,
                                    fecha_subida = dr["fecha_subida"] != DBNull.Value ? Convert.ToDateTime(dr["fecha_subida"]) : DateTime.MinValue
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
                throw new Exception("Error al listar los archivos recientes: " + ex.Message);
            }
            return listaArchivo;
        }

        public string ObtenerNombrePorId(int idArchivo)
        {
            string nombreArchivo = string.Empty;
            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_ObtenerNombreArchivo", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("IdArchivo", idArchivo);

                    conexion.Open();

                    object result = cmd.ExecuteScalar();

                    if (result != null && result != DBNull.Value)
                    {
                        nombreArchivo = result.ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al obtener el nombre de la carpeta: " + ex.Message, ex);
            }
            return nombreArchivo;
        }

        public List<ARCHIVO> ListarArchivos(int id_usuario, out int resultado, out string mensaje)
        {
            List<ARCHIVO> listaArchivo = new List<ARCHIVO>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerArchivos", conexion);
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
                            listaArchivo.Add(
                                new ARCHIVO
                                {
                                    id_archivo = dr["id_archivo"] != DBNull.Value ? Convert.ToInt32(dr["id_archivo"]) : 0,
                                    nombre = dr["nombre_archivo"] != DBNull.Value ? dr["nombre_archivo"].ToString() : string.Empty,
                                    ruta = dr["ruta"] != DBNull.Value ? dr["ruta"].ToString() : string.Empty,
                                    size = dr["size"] != DBNull.Value ? Convert.ToInt32(dr["size"]) : 0,
                                    tipo = dr["tipo"] != DBNull.Value ? dr["tipo"].ToString() : string.Empty,
                                    estado = dr["estado"] != DBNull.Value && Convert.ToBoolean(dr["estado"]),
                                    id_carpeta = dr["fk_id_carpeta"] != DBNull.Value ? Convert.ToInt32(dr["fk_id_carpeta"]) : 0,
                                    nombre_carpeta = dr["nombre_carpeta"] != DBNull.Value ? dr["nombre_carpeta"].ToString() : string.Empty,
                                    fecha_subida = dr["fecha_subida"] != DBNull.Value ? Convert.ToDateTime(dr["fecha_subida"]) : DateTime.MinValue
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
                throw new Exception("Error al listar los archivos recientes: " + ex.Message);
            }
            return listaArchivo;
        }

        public List<ARCHIVO> ListarArchivosPorCarpeta(int idCarpeta, out int resultado, out string mensaje)
        {
            List<ARCHIVO> listaArchivo = new List<ARCHIVO>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerArchivosPorCarpeta", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("IdCarpeta", idCarpeta);

                    // Parámetros de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;

                    // Abrir conexión
                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            listaArchivo.Add(
                                new ARCHIVO
                                {
                                    id_archivo = dr["id_archivo"] != DBNull.Value ? Convert.ToInt32(dr["id_archivo"]) : 0,
                                    nombre = dr["nombre_archivo"] != DBNull.Value ? dr["nombre_archivo"].ToString() : string.Empty,
                                    ruta = dr["ruta"] != DBNull.Value ? dr["ruta"].ToString() : string.Empty,
                                    size = dr["size"] != DBNull.Value ? Convert.ToInt32(dr["size"]) : 0,
                                    tipo = dr["tipo"] != DBNull.Value ? dr["tipo"].ToString() : string.Empty,
                                    estado = dr["estado"] != DBNull.Value && Convert.ToBoolean(dr["estado"]),
                                    id_carpeta = dr["fk_id_carpeta"] != DBNull.Value ? Convert.ToInt32(dr["fk_id_carpeta"]) : 0,
                                    nombre_carpeta = dr["nombre_carpeta"] != DBNull.Value ? dr["nombre_carpeta"].ToString() : string.Empty,
                                    fecha_subida = dr["fecha_subida"] != DBNull.Value ? Convert.ToDateTime(dr["fecha_subida"]) : DateTime.MinValue
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
                throw new Exception("Error al listar los archivos de la carpeta: " + ex.Message);
            }
            return listaArchivo;
        }

        public List<ARCHIVO> BuscarArchivos(string nombre, int id_usuario, out int resultado, out string mensaje)
        {
            List<ARCHIVO> listaArchivo = new List<ARCHIVO>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_BuscarArchivosUsuario", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parámetros de entrada
                    cmd.Parameters.AddWithValue("IdUsuario", id_usuario);
                    cmd.Parameters.AddWithValue("Nombre", nombre);

                    // Parámetros de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;

                    // Abrir conexión
                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            listaArchivo.Add(
                                new ARCHIVO
                                {
                                    id_archivo = dr["id_archivo"] != DBNull.Value ? Convert.ToInt32(dr["id_archivo"]) : 0,
                                    nombre = dr["nombre_archivo"] != DBNull.Value ? dr["nombre_archivo"].ToString() : string.Empty,
                                    ruta = dr["ruta"] != DBNull.Value ? dr["ruta"].ToString() : string.Empty,
                                    size = dr["size"] != DBNull.Value ? Convert.ToInt32(dr["size"]) : 0,
                                    tipo = dr["tipo"] != DBNull.Value ? dr["tipo"].ToString() : string.Empty,
                                    estado = dr["estado"] != DBNull.Value && Convert.ToBoolean(dr["estado"]),
                                    id_carpeta = dr["fk_id_carpeta"] != DBNull.Value ? Convert.ToInt32(dr["fk_id_carpeta"]) : 0,
                                    nombre_carpeta = dr["nombre_carpeta"] != DBNull.Value ? dr["nombre_carpeta"].ToString() : string.Empty,
                                    fecha_subida = dr["fecha_subida"] != DBNull.Value ? Convert.ToDateTime(dr["fecha_subida"]) : DateTime.MinValue
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
                throw new Exception("Error al listar los archivos recientes: " + ex.Message);
            }
            return listaArchivo;
        }

        public List<ARCHIVO> ListarArchivosEliminados(int id_usuario, out int resultado, out string mensaje)
        {
            List<ARCHIVO> listaArchivoEliminado = new List<ARCHIVO>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_VerArchivosEliminadosPorUsuario", conexion);
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
                            listaArchivoEliminado.Add(
                                new ARCHIVO
                                {
                                    id_archivo = dr["id_archivo"] != DBNull.Value ? Convert.ToInt32(dr["id_archivo"]) : 0,
                                    nombre = dr["nombre_archivo"] != DBNull.Value ? dr["nombre_archivo"].ToString() : string.Empty,
                                    ruta = dr["ruta"] != DBNull.Value ? dr["ruta"].ToString() : string.Empty,
                                    size = dr["size"] != DBNull.Value ? Convert.ToInt32(dr["size"]) : 0,
                                    tipo = dr["tipo"] != DBNull.Value ? dr["tipo"].ToString() : string.Empty,
                                    estado = dr["estado"] != DBNull.Value && Convert.ToBoolean(dr["estado"]),
                                    id_carpeta = dr["fk_id_carpeta"] != DBNull.Value ? Convert.ToInt32(dr["fk_id_carpeta"]) : 0,
                                    nombre_carpeta = dr["nombre_carpeta"] != DBNull.Value ? dr["nombre_carpeta"].ToString() : string.Empty,
                                    fecha_subida = dr["fecha_subida"] != DBNull.Value ? Convert.ToDateTime(dr["fecha_subida"]) : DateTime.MinValue,
                                    fecha_eliminacion = dr["fecha_eliminacion"] != DBNull.Value ? Convert.ToDateTime(dr["fecha_eliminacion"]) : DateTime.MinValue
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
                throw new Exception("Error al listar los archivos eliminados: " + ex.Message);
            }
            return listaArchivoEliminado;
        }

        public bool ObtenerRutaArchivoPorId(int idArchivo, out string ruta, out string mensaje)
        {
            ruta = string.Empty;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_ObtenerRutaArchivo", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@IdArchivo", idArchivo);

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

        public int SubirArchivo(ARCHIVO archivo, out string mensaje)
        {
            int idAutogeneradoCarpeta = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_SubirArchivo", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Agregar parámetros
                    cmd.Parameters.AddWithValue("Nombre", archivo.nombre);
                    cmd.Parameters.AddWithValue("Ruta", archivo.ruta);
                    cmd.Parameters.AddWithValue("Size", archivo.size);
                    cmd.Parameters.AddWithValue("Tipo", archivo.tipo);
                    cmd.Parameters.AddWithValue("IdUsuario", archivo.id_usuario);

                    // Manejar Carpeta como NULL si no está especificado
                    if (archivo.id_carpeta.HasValue)
                    {
                        cmd.Parameters.AddWithValue("Carpeta", archivo.id_carpeta.Value);
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("Carpeta", DBNull.Value);
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
                mensaje = "Error al subir el archivo: " + ex.Message;
            }

            return idAutogeneradoCarpeta;
        }

        public bool EliminarArchivo(int id_archivo, out string mensaje)
        {
            bool resultado = false;
            mensaje = string.Empty;
            try
            {
                // Crear conexión
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    // Consulta SQL con parámetros
                    SqlCommand cmd = new SqlCommand("usp_EliminarArchivo", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Agregar parámetro de entrada
                    cmd.Parameters.AddWithValue("IdArchivo", id_archivo);

                    // Agregar parámetro de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Bit).Direction = ParameterDirection.Output;

                    // Abrir conexión
                    conexion.Open();
                    cmd.ExecuteNonQuery();

                    // Obtener valores de los parámetros de salida
                    resultado = cmd.Parameters["Resultado"].Value != DBNull.Value && Convert.ToBoolean(cmd.Parameters["Resultado"].Value);
                    mensaje = resultado ? "Archivo eliminado correctamente" : "El archivo no existe";
                }
            }
            catch (Exception ex)
            {
                resultado = false;
                mensaje = "Error al eliminar el archivo: " + ex.Message;
            }
            return resultado;
        }

        public bool DejarDeCompartirArchivo(int id_archivo, int idUsuarioPropietario, out string mensaje)
        {
            bool resultado = false;
            mensaje = string.Empty;
            try
            {
                // Crear conexión
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    // Consulta SQL con parámetros
                    SqlCommand cmd = new SqlCommand("usp_DejarDeCompartirArchivo", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Agregar parámetro de entrada
                    cmd.Parameters.AddWithValue("IdCompartido", id_archivo);
                    cmd.Parameters.AddWithValue("IdUsuarioPropietario", idUsuarioPropietario);

                    // Agregar parámetro de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;

                    // Abrir conexión
                    conexion.Open();
                    cmd.ExecuteNonQuery();

                    // Obtener valores de los parámetros de salida
                    resultado = cmd.Parameters["Resultado"].Value != DBNull.Value && Convert.ToBoolean(cmd.Parameters["Resultado"].Value);
                    mensaje = cmd.Parameters["Mensaje"].Value.ToString();
                }
            }
            catch (Exception ex)
            {
                resultado = false;
                mensaje = "Error al dejar de compartir el archivo: " + ex.Message;
            }
            return resultado;
        }

        public bool RenombrarArchivo(int idArchivo, string nuevoNombre, out string mensaje)
        {
            bool resultado = false;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_RenombrarArchivo", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("id_archivo", idArchivo);
                    cmd.Parameters.AddWithValue("nuevo_nombre", nuevoNombre);

                    // Parámetros de salida
                    SqlParameter paramMensaje = new SqlParameter("mensaje", SqlDbType.VarChar, 60)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(paramMensaje);

                    SqlParameter paramResultado = new SqlParameter("resultado", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(paramResultado);

                    conexion.Open();
                    cmd.ExecuteNonQuery();

                    mensaje = cmd.Parameters["mensaje"].Value?.ToString();
                    resultado = Convert.ToInt32(cmd.Parameters["resultado"].Value) == 1;
                }
            }
            catch (Exception ex)
            {
                mensaje = "Error al renombrar el archivo: " + ex.Message;
                resultado = false;
            }
            return resultado;
        }

        public bool EliminarArchivoDefinitivamente(int id_archivo, int id_usuario, out string mensaje)
        {
            bool resultado = false;
            mensaje = string.Empty;
            try
            {
                // Crear conexión
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    // Consulta SQL con parámetros
                    SqlCommand cmd = new SqlCommand("usp_EliminarArchivoDefinitivamente", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Agregar parámetro de entrada
                    cmd.Parameters.AddWithValue("IdArchivo", id_archivo);
                    cmd.Parameters.AddWithValue("IdUsuario", id_usuario);

                    // Agregar parámetro de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Bit).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("@Mensaje", SqlDbType.NVarChar, 500).Direction = ParameterDirection.Output;

                    // Abrir conexión
                    conexion.Open();
                    cmd.ExecuteNonQuery();

                    // Obtener valores de los parámetros de salida
                    resultado = cmd.Parameters["Resultado"].Value != DBNull.Value && Convert.ToBoolean(cmd.Parameters["Resultado"].Value);
                    mensaje = cmd.Parameters["@Mensaje"].Value.ToString();

                }
            }
            catch (Exception ex)
            {
                resultado = false;
                mensaje = "Error al eliminar el archivo: " + ex.Message;
            }
            return resultado;
        }

        public bool CompartirArchivo(int idArchivo, int idUsuarioPropietario, int idUsuarioDestino, string permisos, out string mensaje)
        {
            bool respuesta = false;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_CompartirArchivo", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("idArchivo", idArchivo);
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

        public List<ARCHIVOCOMPARTIDO> ObtenerArchivosCompartidosPorMi(int idUsuarioPropietario)
        {
            List<ARCHIVOCOMPARTIDO> lista = new List<ARCHIVOCOMPARTIDO>();

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_ObtenerArchivosCompartidosPorMi", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("IdUsuarioPropietario", idUsuarioPropietario);

                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(new ARCHIVOCOMPARTIDO
                            {
                                IdArchivo = Convert.ToInt32(dr["id_compartido"]),
                                NombreArchivo = dr["nombre_archivo"].ToString(),
                                Ruta = dr["ruta"].ToString(),
                                FechaRegistro = Convert.ToDateTime(dr["fecha_subida"]),
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

        public List<ARCHIVO> ObtenerArchivosCompartidosConmigo(int idUsuario, out int resultado, out string mensaje)
        {
            List<ARCHIVO> lista = new List<ARCHIVO>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_ObtenerArchivosCompartidosConmigo", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parametro de entrada
                    cmd.Parameters.AddWithValue("IdUsuario", idUsuario);

                    // Parámetros de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;

                    // Abrir conexión
                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(new ARCHIVO
                            {

                                id_archivo = dr["id_archivo"] != DBNull.Value ? Convert.ToInt32(dr["id_archivo"]) : 0,
                                nombre = dr["nombre_archivo"] != DBNull.Value ? dr["nombre_archivo"].ToString() : string.Empty,
                                ruta = dr["ruta"] != DBNull.Value ? dr["ruta"].ToString() : string.Empty,
                                size = dr["size"] != DBNull.Value ? Convert.ToInt32(dr["size"]) : 0,
                                tipo = dr["tipo"] != DBNull.Value ? dr["tipo"].ToString() : string.Empty,
                                estado = dr["estado"] != DBNull.Value && Convert.ToBoolean(dr["estado"]),
                                id_carpeta = dr["fk_id_carpeta"] != DBNull.Value ? Convert.ToInt32(dr["fk_id_carpeta"]) : 0,
                                nombre_carpeta = dr["nombre_carpeta"] != DBNull.Value ? dr["nombre_carpeta"].ToString() : string.Empty,
                                propietario = dr["propietario"].ToString(),
                                permisos = dr["permisos"].ToString(),
                                correo = dr["correo"].ToString(),
                                fecha_compartido = Convert.ToDateTime(dr["fecha_compartido"])
                            });
                        }
                    }

                    resultado = Convert.ToInt32(cmd.Parameters["Resultado"].Value);
                    mensaje = cmd.Parameters["Mensaje"].Value.ToString();
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