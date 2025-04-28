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
                    SqlCommand cmd = new SqlCommand("usp_LeerArchivosRecientes", conexion);
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
    }
}