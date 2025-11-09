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
    public class CD_PlanSemestral
    {
        public List<PLANDIDACTICOSEMESTRAL> ListarDatosGenerales(int id_usuario, out int resultado, out string mensaje)
        {
            List<PLANDIDACTICOSEMESTRAL> lst = new List<PLANDIDACTICOSEMESTRAL>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerDatosGeneralesPlanSemestral", conexion);
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
                                new PLANDIDACTICOSEMESTRAL
                                {
                                    //Datos del plan didáctico semestral
                                    id_plan_didactico = Convert.ToInt32(dr["id_plan_didactico"]),
                                    fk_matriz_asignatura = Convert.ToInt32(dr["fk_matriz_asignatura"]),
                                    codigo = dr["codigo"].ToString(),
                                    nombre = dr["nombre"].ToString(),

                                    //Datos de la asignatura
                                    Asignatura = new ASIGNATURA
                                    {
                                        nombre = dr["asignatura"].ToString(),
                                    },

                                    //Datos de la matriz de integración de componentes
                                    Matriz = new MATRIZINTEGRACIONCOMPONENTES
                                    {
                                        codigo = dr["codigo_matriz"].ToString(),
                                        nombre = dr["nombre_matriz"].ToString(),
                                        numero_semanas = Convert.ToInt32(dr["numero_semanas"]),
                                        fecha_inicio = Convert.ToDateTime(dr["fecha_inicio"]),
                                        area = dr["area_conocimiento"].ToString(),
                                        departamento = dr["departamento"].ToString(),
                                        carrera = dr["carrera"].ToString(),
                                        modalidad = dr["modalidad"].ToString(),
                                        usuario = dr["usuario_propietario"].ToString(),
                                        periodo = dr["periodo"].ToString(),
                                        estado = Convert.ToBoolean(dr["estado"]),
                                        estado_proceso = dr["estado_proceso"].ToString(),
                                        fecha_registro = Convert.ToDateTime(dr["fecha_registro"]),
                                    }
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
                throw new Exception("Error al listar los detalles del Plan didactico semestral: " + ex.Message);
            }
            return lst;
        }
    }
}
