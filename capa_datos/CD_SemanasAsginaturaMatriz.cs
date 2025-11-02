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
    public class CD_SemanasAsginaturaMatriz
    {
        // Listar semanas de asignatura matriz
        public List<SEMANASASIGNATURAMATRIZ> Listar(int fk_matriz_asignatura, out int resultado, out string mensaje)
        {
            List<SEMANASASIGNATURAMATRIZ> lista = new List<SEMANASASIGNATURAMATRIZ>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("sp_LeerSemanasAsignatura", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("FKMatrizAsignatura", fk_matriz_asignatura);

                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(new SEMANASASIGNATURAMATRIZ()
                            {
                                id_semana = Convert.ToInt32(dr["id_semana"]),
                                fk_matriz_asignatura = Convert.ToInt32(dr["fk_matriz_asignatura"]),
                                numero_semana = dr["numero_semana"].ToString(),
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

        public List<SEMANASASIGNATURAMATRIZ> ObtenerContenidosPorSemana(int fk_matriz_integracion, string numero_semana, out int resultado, out string mensaje)
        {
            List<SEMANASASIGNATURAMATRIZ> lista = new List<SEMANASASIGNATURAMATRIZ>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_ObtenerContenidosPorSemana", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("FKMatrizIntegracion", fk_matriz_integracion);
                    cmd.Parameters.AddWithValue("NumeroSemana", numero_semana);

                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(new SEMANASASIGNATURAMATRIZ()
                            {
                                numero_semana = dr["numero_semana"].ToString(),
                                asignatura = dr["asignatura"].ToString(),
                                codigo_asignatura = dr["codigo_asignatura"].ToString(),
                                profesor = dr["profesor"] != DBNull.Value ? dr["profesor"].ToString() : "Sin asignar",
                                descripcion = dr["descripcion"] != DBNull.Value ? dr["descripcion"].ToString() : "Sin descripción",
                                fecha_inicio = dr["fecha_inicio"] != DBNull.Value ? Convert.ToDateTime(dr["fecha_inicio"]) : DateTime.MinValue,
                                fecha_fin = dr["fecha_fin"] != DBNull.Value ? Convert.ToDateTime(dr["fecha_fin"]) : DateTime.MinValue,
                                tipo_semana = dr["tipo_semana"] != DBNull.Value ? dr["tipo_semana"].ToString() : "Normal",
                                estado = dr["estado"] != DBNull.Value ? dr["estado"].ToString() : "Pendiente",
                                fecha_registro = dr["fecha_registro"] != DBNull.Value ? Convert.ToDateTime(dr["fecha_registro"]) : DateTime.MinValue
                            });
                        }
                    }

                    resultado = 1;
                    mensaje = "Contenidos cargados correctamente";
                }
            }
            catch (Exception ex)
            {
                resultado = 0;
                mensaje = "Error al listar los contenidos de las asignaturas: " + ex.Message;
            }

            return lista;
        }

        public int Actualizar(SEMANASASIGNATURAMATRIZ semana, out string mensaje)
        {
            int resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_ActualizarSemana", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parámetros de entrada
                    cmd.Parameters.AddWithValue("IdSemana", semana.id_semana);
                    cmd.Parameters.AddWithValue("Descripcion", semana.descripcion);
                    cmd.Parameters.AddWithValue("TipoSemana", semana.tipo_semana);
                    cmd.Parameters.AddWithValue("Estado", semana.estado);

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
                mensaje = "Error al actualizar la asignatura en la matriz: " + ex.Message;
            }

            return resultado;
        }
    }
}
