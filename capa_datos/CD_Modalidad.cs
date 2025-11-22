using capa_entidad;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_datos
{
    public class CD_Modalidad
    {
        //Listar modalidad
        public List<MODALIDAD> Listar()
        {
            List<MODALIDAD> lst = new List<MODALIDAD>();

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerModalidad", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lst.Add(
                                new MODALIDAD
                                {
                                    id_modalidad = Convert.ToInt32(dr["id_modalidad"]),
                                    nombre = dr["nombre"].ToString(),
                                    estado = Convert.ToBoolean(dr["estado"]),
                                    fecha_registro = Convert.ToDateTime(dr["fecha_registro"]),
                                }
                            );
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar las modalidades: " + ex.Message);
            }
            return lst;
        }

        // Crear modalidad
        public int Crear(MODALIDAD modalidad, out string mensaje)
        {
            int idautogenerado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_CrearModalidad", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parámetros de entrada
                    cmd.Parameters.AddWithValue("Nombre", modalidad.nombre);

                    // Parámetros de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 255).Direction = ParameterDirection.Output;

                    // Abrir conexión
                    conexion.Open();

                    // Ejecutar comando
                    cmd.ExecuteNonQuery();

                    // Obtener valores de los parámetros de salida
                    idautogenerado = Convert.ToInt32(cmd.Parameters["Resultado"].Value);
                    mensaje = cmd.Parameters["Mensaje"].Value.ToString();
                }
            }
            catch (Exception ex)
            {
                idautogenerado = 0;
                mensaje = "Error al registrar la modalidad: " + ex.Message;
            }

            return idautogenerado;
        }

        // Editar modalidad
        public bool Editar(MODALIDAD modalidad, out string mensaje)
        {
            bool resultado = false;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_ActualizarModalidad", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parámetros de entrada
                    cmd.Parameters.AddWithValue("IdModalidad", modalidad.id_modalidad);
                    cmd.Parameters.AddWithValue("Nombre", modalidad.nombre);
                    cmd.Parameters.AddWithValue("Estado", modalidad.estado);

                    // Parámetros de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 255).Direction = ParameterDirection.Output;

                    // Abrir conexión
                    conexion.Open();

                    cmd.ExecuteNonQuery();

                    resultado = cmd.Parameters["Resultado"].Value != DBNull.Value && Convert.ToInt32(cmd.Parameters["Resultado"].Value) == 1;
                    mensaje = cmd.Parameters["Mensaje"].Value != DBNull.Value ? cmd.Parameters["Mensaje"].Value.ToString() : "Mensaje no disponible.";
                }
            }
            catch (Exception ex)
            {
                resultado = false;
                mensaje = "Error al actualizar la modalidad: " + ex.Message;
            }

            return resultado;
        }

        // Eliminar modalidad
        public int Eliminar(int idModalidad, out string mensaje)
        {
            int resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_EliminarModalidad", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parámetro de entrada
                    cmd.Parameters.AddWithValue("IdModalidad", idModalidad);

                    // Parámetros de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 255).Direction = ParameterDirection.Output;

                    conexion.Open();
                    cmd.ExecuteNonQuery();

                    resultado = Convert.ToInt32(cmd.Parameters["Resultado"].Value);
                    mensaje = cmd.Parameters["Mensaje"].Value.ToString();
                }
            }
            catch (Exception ex)
            {
                resultado = 0;
                mensaje = "Error al eliminar la modalidad: " + ex.Message;
            }

            return resultado;
        }
    }
}
