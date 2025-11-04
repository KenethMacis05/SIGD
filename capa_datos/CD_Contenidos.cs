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
    public class CD_Contenidos
    {
        // Listar semanas de asignatura matriz
        public List<CONTENIDOS> Listar(int fk_matriz_asignatura, out int resultado, out string mensaje)
        {
            List<CONTENIDOS> lista = new List<CONTENIDOS>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("sp_LeerContenidosAsignatura", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("FKMatrizAsignatura", fk_matriz_asignatura);

                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(new CONTENIDOS()
                            {
                                id_contenido = Convert.ToInt32(dr["id_contenido"]),
                                fk_matriz_asignatura = Convert.ToInt32(dr["fk_matriz_asignatura"]),
                                numero_semana = Convert.ToInt32(dr["numero_semana"]),
                                descripcion_semana = dr["descripcion_semana"].ToString(),
                                contenido = dr["contenido"].ToString(),
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

        public List<CONTENIDOS> ObtenerContenidosPorSemana(int fk_matriz_integracion, int numero_semana, out int resultado, out string mensaje)
        {
            List<CONTENIDOS> lista = new List<CONTENIDOS>();
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
                            lista.Add(new CONTENIDOS()
                            {
                                numero_semana = Convert.ToInt32(dr["numero_semana"]),
                                descripcion_semana = dr["descripcion_semana"].ToString(),
                                asignatura = dr["asignatura"].ToString(),
                                codigo_asignatura = dr["codigo_asignatura"].ToString(),
                                profesor = dr["profesor"] != DBNull.Value ? dr["profesor"].ToString() : "Sin asignar",
                                contenido = dr["contenido"] != DBNull.Value ? dr["contenido"].ToString() : "Sin contenido",
                                fecha_inicio = dr["fecha_inicio"] != DBNull.Value ? Convert.ToDateTime(dr["fecha_inicio"]) : DateTime.MinValue,
                                fecha_fin = dr["fecha_fin"] != DBNull.Value ? Convert.ToDateTime(dr["fecha_fin"]) : DateTime.MinValue,
                                tipo_semana = dr["tipo_semana"] != DBNull.Value ? dr["tipo_semana"].ToString() : "Normal",
                                estado = dr["estado"] != DBNull.Value ? dr["estado"].ToString() : "Pendiente",
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

        public int Actualizar(CONTENIDOS contenido, out string mensaje)
        {
            int resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_ActualizarContenido", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parámetros de entrada
                    cmd.Parameters.AddWithValue("IdContenido", contenido.id_contenido);
                    cmd.Parameters.AddWithValue("Contenido", contenido.contenido);
                    cmd.Parameters.AddWithValue("TipoSemana", contenido.tipo_semana);
                    cmd.Parameters.AddWithValue("Estado", contenido.estado);

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
