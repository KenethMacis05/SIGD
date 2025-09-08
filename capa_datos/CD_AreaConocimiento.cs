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
    public class CD_AreaConocimiento
    {
        //Listar áreas de conocimiento
        public List<AREACONOCIMIENTO> Listar()
        {
            List<AREACONOCIMIENTO> lst = new List<AREACONOCIMIENTO>();

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerAreasDeConocimiento", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lst.Add(
                                new AREACONOCIMIENTO
                                {
                                    id_area = Convert.ToInt32(dr["id_area"]),
                                    codigo = dr["codigo"].ToString(),
                                    nombre = dr["nombre"].ToString(),
                                    fecha_registro = Convert.ToDateTime(dr["fecha_registro"]),
                                    estado = Convert.ToBoolean(dr["estado"]),
                                }
                            );
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar los áreas de conocimiento: " + ex.Message);
            }
            return lst;
        }

        //Crear área de conocimiento
        public int Crear(AREACONOCIMIENTO area, out string mensaje)
        {
            int idautogenerado = 0;
            mensaje = string.Empty;

            try
            {
                // Crear conexión
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    // Consulta SQL con parámetros
                    SqlCommand cmd = new SqlCommand("usp_CrearAreaDeConocimiento", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Agregar parámetros
                    cmd.Parameters.AddWithValue("Nombre", area.nombre);
                    cmd.Parameters.AddWithValue("Codigo", area.codigo);

                    // Parámetros de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;

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
                mensaje = "Error al registrar el área de conocimiento: " + ex.Message;
            }

            return idautogenerado;
        }

        //Editar área de conocimiento
        public bool Editar(AREACONOCIMIENTO area, out string mensaje)
        {
            bool resultado = false;
            mensaje = string.Empty;
            try
            {
                // Crear conexión
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    // Consulta SQL con parámetros
                    SqlCommand cmd = new SqlCommand("usp_ActualizarAreaDeConocimiento", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Agregar parámetros
                    cmd.Parameters.AddWithValue("IdArea", area.id_area);
                    cmd.Parameters.AddWithValue("Nombre", area.nombre);
                    cmd.Parameters.AddWithValue("Codigo", area.codigo ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("Estado", area.estado);

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
                mensaje = "Error al actualizar el área de conocimiento: " + ex.Message;
            }
            return resultado;
        }

        //Eliminar área de conocimiento
        public int Eliminar(int idArea, out string mensaje)
        {
            int resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_EliminarAreaDeConocimiento", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parámetro de entrada
                    cmd.Parameters.AddWithValue("IdArea", idArea);

                    // Parámetros de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;

                    conexion.Open();
                    cmd.ExecuteNonQuery();

                    resultado = Convert.ToInt32(cmd.Parameters["Resultado"].Value);
                    mensaje = cmd.Parameters["Mensaje"].Value.ToString();
                }
            }
            catch (Exception ex)
            {
                resultado = 0;
                mensaje = "Error al eliminar el área de conocimiento: " + ex.Message;
            }

            return resultado;
        }

    }
}
