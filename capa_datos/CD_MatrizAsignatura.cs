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
    public class CD_MatrizAsignatura
    {
        // En CD_MatrizAsignatura
        public List<MATRIZASIGNATURA> ListarAsignaturasPorMatriz(int fk_matriz_integracion, out int resultado, out string mensaje)
        {
            List<MATRIZASIGNATURA> lista = new List<MATRIZASIGNATURA>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerAsignaturasPorMatriz", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("FKMatrizIntegracion", fk_matriz_integracion);

                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(new MATRIZASIGNATURA()
                            {
                                id_matriz_asignatura = Convert.ToInt32(dr["id_matriz_asignatura"]),
                                fk_matriz_integracion = Convert.ToInt32(dr["fk_matriz_integracion"]),
                                fk_asignatura = Convert.ToInt32(dr["fk_asignatura"]),
                                codigo_asignatura = dr["codigo"].ToString(),
                                nombre_asignatura = dr["asignatura"].ToString(),
                                fk_profesor_asignado = Convert.ToInt32(dr["fk_profesor_asignado"]),
                                nombre_profesor = dr["profesor"].ToString(),
                                correo_profesor = dr["correo"].ToString(),
                                estado = dr["estado"].ToString(),
                                fecha_registro = Convert.ToDateTime(dr["fecha_registro"])
                            });
                        }
                    }

                    resultado = 1;
                    mensaje = "Asignaturas cargadas correctamente";
                }
            }
            catch (Exception ex)
            {
                resultado = 0;
                mensaje = "Error al listar las asignaturas: " + ex.Message;
            }

            return lista;
        }
        
        public int AsignarAsignaturaMatriz(MATRIZASIGNATURA matriz, out string mensaje)
        {
            int idautogenerado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_AsignarAsignaturaMatriz", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parámetros de entrada
                    cmd.Parameters.AddWithValue("FKMatrizIntegracion", matriz.fk_matriz_integracion);
                    cmd.Parameters.AddWithValue("FKAsignatura", matriz.fk_asignatura);
                    cmd.Parameters.AddWithValue("FKProfesorPropietario", matriz.fk_profesor_propietario);
                    cmd.Parameters.AddWithValue("FKProfesorAsignado", matriz.fk_profesor_asignado);
                    
                    // Parámetros de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 255).Direction = ParameterDirection.Output;

                    conexion.Open();
                    cmd.ExecuteNonQuery();

                    idautogenerado = Convert.ToInt32(cmd.Parameters["Resultado"].Value);
                    mensaje = cmd.Parameters["Mensaje"].Value.ToString();
                }
            }
            catch (Exception ex)
            {
                idautogenerado = 0;
                throw new Exception("Error al asignar la asignatura: " + ex.Message);
            }

            return idautogenerado;
        }
    }
}
