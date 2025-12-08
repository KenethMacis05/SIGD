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
    public class CD_PlanificacionIndividual
    {
        public List<PLANIFICACIONINDIVIDUALSEMESTRAL> Listar(int fk_pla_semestral, out int resultado, out string mensaje)
        {
            List<PLANIFICACIONINDIVIDUALSEMESTRAL> lista = new List<PLANIFICACIONINDIVIDUALSEMESTRAL>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerPlanificacionIndividualPorId", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("FKPlanSemestral", fk_pla_semestral);

                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(new PLANIFICACIONINDIVIDUALSEMESTRAL()
                            {
                                id_planificacion = Convert.ToInt32(dr["id_planificacion"]),
                                fk_plan_didactico = Convert.ToInt32(dr["fk_plan_didactico"]),
                                fk_contenido = Convert.ToInt32(dr["fk_contenido"]),

                                SEMANA = new SEMANAS
                                {
                                    descripcion = dr["semana"].ToString(),
                                    tipo_semana = dr["tipo_semana"].ToString(),
                                    numero_semana = Convert.ToInt32(dr["numero_semana"])
                                },

                                PLANSEMESTRAL = new PLANDIDACTICOSEMESTRAL
                                {
                                    objetivos_aprendizaje = dr["objetivos_aprendizaje"].ToString()
                                },

                                CONTENIDO = new CONTENIDOS
                                {
                                    contenido = dr["contenido"].ToString()
                                },

                                estrategias_aprendizaje = dr["estrategias_aprendizaje"].ToString(),
                                estrategias_evaluacion = dr["estrategias_evaluacion"].ToString(),
                                tipo_evaluacion = dr["tipo_evaluacion"].ToString(),
                                instrumento_evaluacion = dr["instrumento_evaluacion"].ToString(),
                                evidencias_aprendizaje = dr["evidencias_aprendizaje"].ToString()
                            });
                        }
                    }

                    resultado = 1;
                    mensaje = "Plan individual cargado correctamente";
                }
            }
            catch (Exception ex)
            {
                resultado = 0;
                mensaje = "Error al listar los planes individuales del plan semestral: " + ex.Message;
            }

            return lista;
        }

        public int Actualizar(PLANIFICACIONINDIVIDUALSEMESTRAL plan, out string mensaje)
        {
            int resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_ActualizarPlanificacionIndividual", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parámetros de entrada
                    cmd.Parameters.AddWithValue("IdPlanificacion", plan.id_planificacion);
                    cmd.Parameters.AddWithValue("EstrategiaAprendizaje", plan.estrategias_aprendizaje);
                    cmd.Parameters.AddWithValue("EstrategiaEvaluacion", plan.estrategias_evaluacion);
                    cmd.Parameters.AddWithValue("TipoEvaluacion", plan.tipo_evaluacion);
                    cmd.Parameters.AddWithValue("InstrumentoEvaluacion", plan.instrumento_evaluacion);
                    cmd.Parameters.AddWithValue("EvidenciasAprendizaje", plan.evidencias_aprendizaje);

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
                mensaje = "Error al actualizar el plan: " + ex.Message;
            }

            return resultado;
        }
    }
}
