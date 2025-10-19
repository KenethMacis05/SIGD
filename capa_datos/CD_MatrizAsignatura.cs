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
    public class CD_MatrizAsignatura
    {
        public int AsignarAsignaturaMatriz(MATRIZASIGNATURA matriz, out string mensaje)
        {
            int idautogenerado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_AsignarAsignaturaMatriz", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parámetros de entrada
                    cmd.Parameters.AddWithValue("FKMatrizIntegracion", matriz.fk_matriz_integracion);
                    cmd.Parameters.AddWithValue("FKAsignatura", matriz.fk_asignatura);
                    cmd.Parameters.AddWithValue("FKProfesorPropietario", matriz.fk_profesor_propietario);
                    cmd.Parameters.AddWithValue("FKProfesorAsignado", matriz.fk_profesor_asignado);
                    
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
                throw new Exception("Error al asignar la asignatura: " + ex.Message);
            }

            return idautogenerado;
        }
    }
}
