using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using capa_entidad;

namespace capa_datos
{
    public class CD_Archivo
    {
        //// Listar archivos
        public List<ARCHIVO> ListarArchivosRecientes(int id_usuario, out int resultado, out string mensaje)
        {
            List<ARCHIVO> listaArchivo = new List<ARCHIVO>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerArchivosRecientes", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parámetro de entrada
                    cmd.Parameters.AddWithValue("IdUsuario", id_usuario);

                    // Parámetros de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;

                    // Abrir conexión
                    conexion.Open();

                    // Leer los datos
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            ARCHIVO archivo = new ARCHIVO
                            {
                                id_archivo = Convert.ToInt32(dr["id_archivo"]),
                                nombre = dr["nombre_archivo"].ToString(),
                                ruta = dr["ruta"].ToString(),
                                size = Convert.ToInt32(dr["size"]),
                                tipo = dr["tipo"].ToString(),
                                estado = Convert.ToBoolean(dr["estado"]),
                                id_carpeta = Convert.ToInt32(dr["fk_id_carpeta"]),
                                nombre_carpeta = dr["nombre_carpeta"].ToString(),
                                fecha_subida = Convert.ToDateTime(dr["fecha_subida"])
                            };

                            listaArchivo.Add(archivo);
                        }
                    }

                    // Obtener los valores de los parámetros de salida
                    resultado = Convert.ToInt32(cmd.Parameters["Resultado"].Value);
                    mensaje = cmd.Parameters["Mensaje"].Value.ToString();
                }
            }
            catch (Exception ex)
            {
                // Manejar excepciones y lanzar un mensaje claro
                throw new Exception("Error al listar los archivos recientes: " + ex.Message);
            }

            return listaArchivo;
        }

        //public bool SubirArchivo(ARCHIVO archivo, out string mensaje)
        //{

        //}
    }
}
