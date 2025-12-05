// capa_presentacion/ReportesRDLC/ReporteDataHelper.cs
using System;
using System.Data;
using System.Data.SqlClient;

namespace capa_presentacion.ReportesRDLC
{
    public static class ReporteDataHelper
    {
        public static DataTable EjecutarConsultaReporte(string query, SqlParameter[] parametros = null)
        {
            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(capa_datos.Conexion.conexion))
            {
                try
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        if (parametros != null)
                        {
                            cmd.Parameters.AddRange(parametros);
                        }

                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception($"Error en consulta de reporte: {ex.Message}");
                }
            }

            return dt;
        }

        public static SqlParameter CrearParametro(string nombre, object valor)
        {
            return new SqlParameter(nombre, valor ?? DBNull.Value);
        }
    }
}