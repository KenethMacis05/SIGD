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
    public class CD_Modalidad
    {
        //Listar modalidad
        public List<MODALIDAD> Listar()
        {
            List<MODALIDAD> lst = new List<MODALIDAD>();

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerModalidad", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lst.Add(
                                new MODALIDAD
                                {
                                    id_modalidad = Convert.ToInt32(dr["id_modalidad"]),
                                    nombre = dr["nombre"].ToString(),
                                    estado = Convert.ToBoolean(dr["estado"]),
                                    fecha_registro = Convert.ToDateTime(dr["fecha_registro"]),
                                }
                            );
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar las modalidades: " + ex.Message);
            }
            return lst;
        }
    }
}
