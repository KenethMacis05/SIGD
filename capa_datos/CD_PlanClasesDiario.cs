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
        // Listar datos generales de los planes de clases del usuario
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
                                    // 1. Datos del plan de clases diario
                                    id_plan_diario = Convert.ToInt32(dr["id_plan_diario"]),
                                    codigo = dr["codigo"].ToString(),
                                    nombre = dr["nombre"].ToString(),
                                    fk_plan_didactico = Convert.ToInt32(dr["fk_plan_didactico"]),
                                    fk_tema = Convert.ToInt32(dr["fk_tema"]),
                                    fk_plan_individual = Convert.ToInt32(dr["fk_plan_individual"]),
                                    ejes = dr["ejes"].ToString(),
                                    competencias_genericas = dr["competencias_genericas"].ToString(),
                                    competencias_especificas = dr["competencias_especificas"].ToString(),
                                    BOA = dr["BOA"].ToString(),
                                    fecha_inicio = Convert.ToDateTime(dr["fecha_inicio"]),
                                    fecha_fin = Convert.ToDateTime(dr["fecha_fin"]),
                                    objetivo_aprendizaje = dr["objetivo_aprendizaje"].ToString(),
                                    indicador_logro = dr["indicador_logro"].ToString(),
                                    tareas_iniciales = dr["tareas_iniciales"].ToString(),
                                    tareas_desarrollo = dr["tareas_desarrollo"].ToString(),
                                    tareas_sintesis = dr["tareas_sintesis"].ToString(),

                                    // 2. Datos relacionados
                                    area_conocimiento = dr["area_conocimiento"].ToString(),
                                    departamento = dr["departamento"].ToString(),
                                    carrera = dr["carrera"].ToString(),
                                    asignatura = dr["asignatura"].ToString(),
                                    periodo = dr["periodo"].ToString(),
                                    profesor = dr["profesor"].ToString(),
                                    tema = dr["tema"].ToString(),
                                    contenido = dr["contenido(s)"].ToString(),

                                    // 3. Evaluación de los aprendizajes
                                    tipo_evaluacion = dr["tipo_evaluacion"].ToString(),
                                    estrategias_evaluacion = dr["estrategias_evaluacion"].ToString(),
                                    instrumento_evaluacion = dr["instrumento_evaluacion"].ToString(),
                                    evidencias_aprendizaje = dr["evidencias_aprendizaje"].ToString(),

                                    estado = Convert.ToBoolean(dr["estado"]),
                                    fecha_registro = Convert.ToDateTime(dr["fecha_registro"])
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

        public PLANCLASESDIARIO ObtenerPlanDiarioPorId(int id_plan_diario, int id_usuario)
        {
            int resultado;
            string mensaje;

            List<PLANCLASESDIARIO> planes = ListarPlanClasesDiario(id_usuario, out resultado, out mensaje);

            PLANCLASESDIARIO plan = planes.FirstOrDefault(p => p.id_plan_diario == id_plan_diario);

            return plan;
        }

        public int RegistrarPlanClasesDiario(PLANCLASESDIARIO plan, out string mensaje)
        {
            int idautogenerado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_CrearPLanClasesDiario", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parámetros de entrada
                    cmd.Parameters.AddWithValue("Nombre", plan.nombre);
                    cmd.Parameters.AddWithValue("FKPlanDidactico", plan.fk_plan_didactico);
                    cmd.Parameters.AddWithValue("FKTema", plan.fk_tema);
                    cmd.Parameters.AddWithValue("FKPlanIndividual", plan.fk_plan_individual);
                    cmd.Parameters.AddWithValue("Ejes", plan.ejes);
                    cmd.Parameters.AddWithValue("CompetenciasGenericas", plan.competencias_genericas);
                    cmd.Parameters.AddWithValue("CompetenciasEspecificas", plan.competencias_especificas);
                    cmd.Parameters.AddWithValue("BOA", plan.BOA);
                    cmd.Parameters.AddWithValue("FechaInicio", plan.fecha_inicio);
                    cmd.Parameters.AddWithValue("FechaFin", plan.fecha_fin);
                    cmd.Parameters.AddWithValue("ObjetivoAprendizaje", plan.objetivo_aprendizaje);
                    cmd.Parameters.AddWithValue("IndicadorLogro", plan.indicador_logro);
                    cmd.Parameters.AddWithValue("TareasIniciales", plan.tareas_iniciales);
                    cmd.Parameters.AddWithValue("TareasDesarrollo", plan.tareas_desarrollo);
                    cmd.Parameters.AddWithValue("TareasSintesis", plan.tareas_sintesis);

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
                mensaje = "Error al registrar el plan de clases diario: " + ex.Message;
            }

            return idautogenerado;
        }

        // Actualizar plan de clases diario
        public bool ActualizarPlanClasesDiario(PLANCLASESDIARIO plan, out string mensaje)
        {
            bool resultado = false;
            mensaje = string.Empty;
            try
            {
                // Crear conexión
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    // Consulta SQL con parámetros
                    SqlCommand cmd = new SqlCommand("usp_ActualizarPlanClasesDiario", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Agregar parámetros
                    cmd.Parameters.AddWithValue("IdPlanClasesDiario", plan.id_plan_diario);
                    cmd.Parameters.AddWithValue("Nombre", plan.nombre);
                    cmd.Parameters.AddWithValue("FKPlanDidactico", plan.fk_plan_didactico);
                    cmd.Parameters.AddWithValue("FKTema", plan.fk_tema);
                    cmd.Parameters.AddWithValue("FKPlanIndividual", plan.fk_plan_individual);
                    cmd.Parameters.AddWithValue("Ejes", plan.ejes);
                    cmd.Parameters.AddWithValue("CompetenciasGenericas", plan.competencias_genericas);
                    cmd.Parameters.AddWithValue("CompetenciasEspecificas", plan.competencias_especificas);
                    cmd.Parameters.AddWithValue("BOA", plan.BOA);
                    cmd.Parameters.AddWithValue("FechaInicio", plan.fecha_inicio);
                    cmd.Parameters.AddWithValue("FechaFin", plan.fecha_fin);
                    cmd.Parameters.AddWithValue("ObjetivoAprendizaje", plan.objetivo_aprendizaje);
                    cmd.Parameters.AddWithValue("IndicadorLogro", plan.indicador_logro);
                    cmd.Parameters.AddWithValue("TareasIniciales", plan.tareas_iniciales);
                    cmd.Parameters.AddWithValue("TareasDesarrollo", plan.tareas_desarrollo);
                    cmd.Parameters.AddWithValue("TareasSintesis", plan.tareas_sintesis);


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
                mensaje = "Error al actualizar el plan de clases diario: " + ex.Message;
            }
            return resultado;
        }

        public bool EliminarPlanClasesDiario(int id_plan, int id_usuario, out string mensaje)
        {
            bool resultado = false;
            mensaje = string.Empty;
            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_EliminarPlanClasesDiario", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("IdPlanClasesDiario", id_plan);
                    cmd.Parameters.AddWithValue("IdUsuario", id_usuario);

                    cmd.Parameters.Add("Resultado", SqlDbType.Bit).Direction = ParameterDirection.Output;

                    conexion.Open();
                    cmd.ExecuteNonQuery();

                    resultado = cmd.Parameters["Resultado"].Value != DBNull.Value && Convert.ToBoolean(cmd.Parameters["Resultado"].Value);
                    mensaje = resultado ? "Plan de clases eliminado correctamente" : "El plan de clases no existe";
                }
            }
            catch (Exception ex)
            {
                resultado = false;
                mensaje = "Error al eliminar el plan de clases: " + ex.Message;
            }
            return resultado;
        }
    }
}
