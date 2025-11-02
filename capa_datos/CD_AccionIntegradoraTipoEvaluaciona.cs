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
    public class CD_AccionIntegradoraTipoEvaluaciona
    {
        public List<ACCIONINTEGRADORA_TIPOEVALUACION> ListarPorMatriz(int fk_matriz_integracion, out int resultado, out string mensaje)
        {
            List<ACCIONINTEGRADORA_TIPOEVALUACION> lista = new List<ACCIONINTEGRADORA_TIPOEVALUACION>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerAccionIntegradoraTipoEvaluacion", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("FKMatrizIntegracion", fk_matriz_integracion);

                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(new ACCIONINTEGRADORA_TIPOEVALUACION()
                            {
                                id_accion_tipo = Convert.ToInt32(dr["id_accion_tipo"]),
                                fk_matriz_integracion = Convert.ToInt32(dr["fk_matriz_integracion"]),
                                nombre_matriz = dr["nombre_matriz"].ToString(),
                                codigo_matriz = dr["codigo_matriz"].ToString(),
                                numero_semana = dr["numero_semana"].ToString(),
                                accion_integradora = dr["accion_integradora"].ToString(),
                                tipo_evaluacion = dr["tipo_evaluacion"].ToString(),
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
    }
}
