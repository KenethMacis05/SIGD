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
    public class CD_TipoDominio
    {
        public List<TIPODOMINIO> Listar()
        {
            List<TIPODOMINIO> lst = new List<TIPODOMINIO>();

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerTipoDominio", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lst.Add(
                                new TIPODOMINIO
                                {
                                    id_tipo_dominio = Convert.ToInt32(dr["id_tipo_dominio"]),
                                    descripcion_tipo_dominio = dr["descripcion_tipo_dominio"].ToString(),
                                    nombre_procedimiento = dr["nombre_procedimiento"].ToString(),
                                    fecha_registro = Convert.ToDateTime(dr["fecha_registro"]),
                                    estado = Convert.ToBoolean(dr["estado"]),
                                }
                            );
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar los tipos de dominio: " + ex.Message);
            }
            return lst;
        }
    }
}
