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
    public class CD_TemasPlanificacionSemestral
    {
        public List<TEMAPLANIFICACIONSEMESTRAL> Listar(int fk_pla_semestral, out int resultado, out string mensaje)
        {
            List<TEMAPLANIFICACIONSEMESTRAL> lista = new List<TEMAPLANIFICACIONSEMESTRAL>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerTemasPlanSemestralPorId", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("FKPlanSemestral", fk_pla_semestral);

                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(new TEMAPLANIFICACIONSEMESTRAL()
                            {
                                id_tema = Convert.ToInt32(dr["id_tema"]),
                                fk_plan_didactico = Convert.ToInt32(dr["fk_plan_didactico"]),
                                tema = dr["tema"].ToString(),
                                horas_teoricas = Convert.ToInt32(dr["horas_teoricas"]),
                                horas_laboratorio = Convert.ToInt32(dr["horas_laboratorio"]),
                                horas_practicas = Convert.ToInt32(dr["horas_practicas"]),
                                horas_investigacion = Convert.ToInt32(dr["horas_investigacion"]),
                            });
                        }
                    }

                    resultado = 1;
                    mensaje = "Temas cargados correctamente";
                }
            }
            catch (Exception ex)
            {
                resultado = 0;
                mensaje = "Error al listar los temas del plan semestral: " + ex.Message;
            }

            return lista;
        }

        public int Crear(TEMAPLANIFICACIONSEMESTRAL tema, out string mensaje)
        {
            int idautogenerado = 0;
            mensaje = string.Empty;

            try
            {
                // Crear conexión
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    // Consulta SQL con parámetros
                    SqlCommand cmd = new SqlCommand("usp_CrearTemaPlanSemestral", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Agregar parámetros
                    cmd.Parameters.AddWithValue("Tema", tema.tema);
                    cmd.Parameters.AddWithValue("FKPlanSemestral", tema.fk_plan_didactico);
                    cmd.Parameters.AddWithValue("HorasInvestigacion", tema.horas_investigacion);
                    cmd.Parameters.AddWithValue("HorasLaboratorio", tema.horas_laboratorio);
                    cmd.Parameters.AddWithValue("HorasPracticas", tema.horas_practicas);
                    cmd.Parameters.AddWithValue("HorasTeoricas", tema.horas_teoricas);

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
                mensaje = "Error al registrar el tema: " + ex.Message;
            }

            return idautogenerado;
        }

        public bool Editar(TEMAPLANIFICACIONSEMESTRAL tema, out string mensaje)
        {
            bool resultado = false;
            mensaje = string.Empty;
            try
            {
                // Crear conexión
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    // Consulta SQL con parámetros
                    SqlCommand cmd = new SqlCommand("usp_ActualizarTemaPlanSemestral", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Agregar parámetros
                    cmd.Parameters.AddWithValue("IdTema", tema.id_tema);
                    cmd.Parameters.AddWithValue("Tema", tema.tema);
                    cmd.Parameters.AddWithValue("FKPlanSemestral", tema.fk_plan_didactico);
                    cmd.Parameters.AddWithValue("HorasInvestigacion", tema.horas_investigacion);
                    cmd.Parameters.AddWithValue("HorasLaboratorio", tema.horas_laboratorio);
                    cmd.Parameters.AddWithValue("HorasPracticas", tema.horas_practicas);
                    cmd.Parameters.AddWithValue("HorasTeoricas", tema.horas_teoricas);

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
                mensaje = "Error al actualizar el tema: " + ex.Message;
            }
            return resultado;
        }

        public int Eliminar(int id_tema, out string mensaje)
        {
            int resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_EliminarTemaPlanSemestral", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parámetro de entrada
                    cmd.Parameters.AddWithValue("IdTema", id_tema);

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
                mensaje = "Error al eliminar el tema: " + ex.Message;
            }

            return resultado;
        }
    }
}
