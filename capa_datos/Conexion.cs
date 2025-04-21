using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using System.Data.SqlClient;

namespace capa_datos
{
    public class Conexion
    {        
        public static string conexion;

        static Conexion()
        {
            try
            {
                conexion = ConfigurationManager.ConnectionStrings["cadena"].ConnectionString;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al obtener la cadena de conexión: " + ex.Message);
            }
        }
    }
}
