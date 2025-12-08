// ReportesRDLC/Generadores/MatrizIntegracionGenerador.cs
using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace capa_presentacion.ReportesRDLC.Generadores
{
    public class MatrizIntegracionGenerador : IReporteGenerador
    {
        private string _idMatriz;

        public MatrizIntegracionGenerador(string idMatriz)
        {
            _idMatriz = idMatriz;
        }

        public string NombreReporte => "MatrizIntegracionComponente";

        public Dictionary<string, object> ObtenerParametros()
        {
            return new Dictionary<string, object>
            {
                { "IdMatrizIntegracionInforme", _idMatriz }
            };
        }

        public List<ReportDataSource> ObtenerDataSources()
        {
            var dataSources = new List<ReportDataSource>();

            // DataSet 1: Datos principales (Usp_ObtenerMatrizComplete)
            DataTable dtMatriz = ObtenerMatrizComplete();
            dataSources.Add(new ReportDataSource("Usp_ObtenerMatrizComplete", dtMatriz));

            //// DataSet 2: Semanas (Usp_ObtenerSemanasMatriz)
            //DataTable dtSemanas = ObtenerSemanasMatriz();
            //dataSources.Add(new ReportDataSource("Usp_ObtenerSemanasMatriz", dtSemanas));

            return dataSources;
        }

        private DataTable ObtenerMatrizComplete()
        {
            using (SqlConnection con = new SqlConnection(capa_datos.Conexion.conexion))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand("Usp_ObtenerMatrizComplete", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@IdMatrizIntegracionInforme", _idMatriz);

                    DataTable dt = new DataTable();
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }

                    // IMPORTANTE: El nombre del DataTable debe coincidir con el DataSet en RDLC
                    dt.TableName = "Usp_ObtenerMatrizComplete";
                    return dt;
                }
            }
        }

        private DataTable ObtenerSemanasMatriz()
        {
            using (SqlConnection con = new SqlConnection(capa_datos.Conexion.conexion))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand("Usp_ObtenerSemanasMatriz", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@IdMatrizIntegracionInforme", _idMatriz);

                    DataTable dt = new DataTable();
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }

                    dt.TableName = "Usp_ObtenerSemanasMatriz";
                    return dt;
                }
            }
        }
    }
}