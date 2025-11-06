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
    public class CD_Semanas
    {
        // Listar semanas de una matriz de integracion
        public List<SEMANAS> Listar(int fk_matriz_integracion, out int resultado, out string mensaje)
        {
            List<SEMANAS> lista = new List<SEMANAS>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerSemanasPorMatriz", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("FKMatrizIntegracion", fk_matriz_integracion);

                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(new SEMANAS()
                            {
                                id_semana = Convert.ToInt32(dr["id_semana"]),
                                fk_matriz_integracion = Convert.ToInt32(dr["fk_matriz_integracion"]),
                                numero_semana = Convert.ToInt32(dr["numero_semana"]),
                                descripcion = dr["descripcion"].ToString(),
                                fecha_inicio = Convert.ToDateTime(dr["fecha_inicio"]),
                                fecha_fin = Convert.ToDateTime(dr["fecha_fin"]),
                                tipo_semana = dr["tipo_semana"].ToString(),
                                estado = dr["estado"].ToString(),
                                fecha_registro = Convert.ToDateTime(dr["fecha_registro"])
                            });
                        }
                    }

                    resultado = 1;
                    mensaje = "Semanas cargadas correctamente";
                }
            }
            catch (Exception ex)
            {
                resultado = 0;
                mensaje = "Error al listar las semanas de la asignatura: " + ex.Message;
            }

            return lista;
        }

        public int Actualizar(SEMANAS semana, out string mensaje)
        {
            int resultado = 0;
            mensaje = string.Empty;
            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_ActualizarSemana", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parametros de entrada
                    cmd.Parameters.AddWithValue("IDSemana", semana.id_semana);
                    cmd.Parameters.AddWithValue("Descripcion", semana.descripcion);
                    cmd.Parameters.AddWithValue("FechaInicio", semana.fecha_inicio);
                    cmd.Parameters.AddWithValue("FechaFin", semana.fecha_fin);
                    cmd.Parameters.AddWithValue("TipoSemana", semana.tipo_semana);

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
                mensaje = "Error al actualizar la semana: " + ex.Message;
            }
            return resultado;
        }
    }
}
