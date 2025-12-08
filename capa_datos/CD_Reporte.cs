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
    public class CD_Reporte
    {
        //Listar reportes por dominios
        public List<REPORTE> ListarPorDominios(int UsuarioId)
        {
            List<REPORTE> lst = new List<REPORTE>();

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("GetReporte", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("UsuarioId", UsuarioId);

                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lst.Add(
                                new REPORTE
                                {
                                    id_reporte = Convert.ToInt32(dr["Id"]),
                                    nombre = dr["Nombre"].ToString(),
                                    descripcion = dr["Descripcion"].ToString(),
                                }
                            );
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar los dominios por reportes: " + ex.Message);
            }
            return lst;
        }
    }
}
