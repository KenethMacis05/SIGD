using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_datos
{
    public class CD_Dashboard
    {
        public int ContarMatricesAsignaturasPendientes(int idProfesor)
        {
            int totalPendientes = 0;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("SELECT dbo.ContarMatricesAsignaturasPendientes(@IdProfesor)", conexion);
                    cmd.Parameters.AddWithValue("@IdProfesor", idProfesor);

                    conexion.Open();
                    object result = cmd.ExecuteScalar();

                    if (result != null && result != DBNull.Value)
                    {
                        totalPendientes = Convert.ToInt32(result);
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al contar matrices/asignaturas pendientes: " + ex.Message, ex);
            }

            return totalPendientes;
        }

        public string ObtenerAlmacenamientoUsuario(int idUsuario)
        {
            string almacenamiento = "0 B";

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("SELECT dbo.CalcularAlmacenamientoUsuario(@IdUsuario)", conexion);
                    cmd.Parameters.AddWithValue("@IdUsuario", idUsuario);

                    conexion.Open();
                    object result = cmd.ExecuteScalar();

                    if (result != null && result != DBNull.Value)
                    {
                        almacenamiento = result.ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al calcular almacenamiento del usuario: " + ex.Message, ex);
            }

            return almacenamiento;
        }

        public int ContarArchivosCompartidosPorMi(int idUsuario)
        {
            int totalArchivos = 0;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("SELECT dbo.ContarArchivosCompartidosPorMi(@IdUsuario)", conexion);
                    cmd.Parameters.AddWithValue("@IdUsuario", idUsuario);

                    conexion.Open();
                    object result = cmd.ExecuteScalar();

                    if (result != null && result != DBNull.Value)
                    {
                        totalArchivos = Convert.ToInt32(result);
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al contar archivos compartidos: " + ex.Message, ex);
            }

            return totalArchivos;
        }

        // Para obtener el avance global (si tienes esa función)
        public decimal ObtenerAvanceGlobal(int idProfesor)
        {
            decimal avance = 0;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("SELECT dbo.ObtenerAvanceGlobal(@IdProfesor)", conexion);
                    cmd.Parameters.AddWithValue("@IdProfesor", idProfesor);

                    conexion.Open();
                    object result = cmd.ExecuteScalar();

                    if (result != null && result != DBNull.Value)
                    {
                        avance = Convert.ToDecimal(result);
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al obtener avance global: " + ex.Message, ex);
            }

            return avance;
        }

        // Para obtener contenidos pendientes urgentes
        public int ObtenerContenidosPendientesUrgentes(int idProfesor)
        {
            int contenidosUrgentes = 0;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("SELECT dbo.ObtenerContenidosPendientesUrgentes(@IdProfesor)", conexion);
                    cmd.Parameters.AddWithValue("@IdProfesor", idProfesor);

                    conexion.Open();
                    object result = cmd.ExecuteScalar();

                    if (result != null && result != DBNull.Value)
                    {
                        contenidosUrgentes = Convert.ToInt32(result);
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al obtener contenidos urgentes: " + ex.Message, ex);
            }

            return contenidosUrgentes;
        }
    }
}
