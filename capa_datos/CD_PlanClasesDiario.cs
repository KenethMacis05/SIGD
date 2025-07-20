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
    public class CD_PlanClasesDiario
    {
        // Listar planes de clases del usuario
        public List<PLANCLASESDIARIO> ListarPlanClasesDiario(int id_usuario, out int resultado, out string mensaje)
        {
            List<PLANCLASESDIARIO> lst = new List<PLANCLASESDIARIO>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerPlanesDeClases", conexion);
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
                            lst.Add(
                                new PLANCLASESDIARIO
                                {
                                    id_plan_diario = Convert.ToInt32(dr["id_plan_diario"]),
                                    codigo = dr["codigo"].ToString(),
                                    nombre = dr["nombre"].ToString(),
                                    fecha_registro = Convert.ToDateTime(dr["fecha_registro"]),
                                    area_conocimiento = dr["areaConocimiento"].ToString(),
                                    departamento = dr["departamento"].ToString(),
                                    carrera = dr["carrera"].ToString(),
                                    ejes = dr["ejes"].ToString(),
                                    asignatura = dr["asignatura"].ToString(),
                                    fk_profesor = Convert.ToInt32(dr["fk_profesor"]),
                                    fk_periodo = Convert.ToInt32(dr["fk_periodo"]),
                                    competencias = dr["competencias"].ToString(),
                                    BOA = dr["BOA"].ToString(),
                                    fecha_inicio = Convert.ToDateTime(dr["fecha_inicio"]),
                                    fecha_fin = Convert.ToDateTime(dr["fecha_fin"]),
                                    objetivo_aprendizaje = dr["objetivo_aprendizaje"].ToString(),
                                    tema_contenido = dr["tema_contenido"].ToString(),
                                    indicador_logro = dr["indicador_logro"].ToString(),
                                    tareas_iniciales = dr["tareas_iniciales"].ToString(),
                                    tareas_desarrollo = dr["tareas_desarrollo"].ToString(),
                                    tareas_sintesis = dr["tareas_sintesis"].ToString(),
                                    estrategia_evaluacion = dr["estrategia_evaluacion"].ToString(),
                                    instrumento_evaluacion = dr["instrumento_evaluacion"].ToString(),
                                    evidencias_aprendizaje = dr["evidencias_aprendizaje"].ToString(),
                                    criterios_aprendizaje = dr["criterios_aprendizaje"].ToString(),
                                    indicadores_aprendizaje = dr["indicadores_aprendizaje"].ToString(),
                                    nivel_aprendizaje = dr["nivel_aprendizaje"].ToString(),
                                    estado = Convert.ToBoolean(dr["estado"]),
                                    profesor = dr["profesor"].ToString(),
                                    periodo = dr["periodo"].ToString()
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
                throw new Exception("Error al listar los planes de clases: " + ex.Message);
            }
            return lst;
        }

        public bool EliminarPlanClasesDiario(int id_plan_diario, out string mensaje)
        {
            mensaje = "";
            bool resultado = false;
            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_EliminarPlanClasesDiario", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("id_plan_diario", id_plan_diario);

                    cmd.Parameters.Add("Resultado", SqlDbType.Bit).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;

                    conexion.Open();
                    cmd.ExecuteNonQuery();

                    resultado = Convert.ToBoolean(cmd.Parameters["Resultado"].Value);
                    mensaje = cmd.Parameters["Mensaje"].Value.ToString();
                }
            }
            catch (Exception ex)
            {
                mensaje = "Error en base de datos: " + ex.Message;
            }
            return resultado;
        }
    }
}
