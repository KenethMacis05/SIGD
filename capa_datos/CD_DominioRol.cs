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
    public class CD_DominioRol
    {
        public List<DOMINIOROL> ObtenerDominioPorRol(int IdRol, int IdDominio)
        {

            List<DOMINIOROL> lst = new List<DOMINIOROL>();

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {

                    SqlCommand cmd = new SqlCommand("usp_LeerDominiosPorRol", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("IdRol", IdRol);
                    cmd.Parameters.AddWithValue("IdDominio", IdDominio);

                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lst.Add(
                                new DOMINIOROL
                                {
                                    Dominio = new DOMINIO
                                    {
                                        id_dominio = Convert.ToInt32(dr["id_dominio"]),
                                        descripcion_dominio = dr["descripcion_dominio"].ToString(),
                                        referencia_id = Convert.ToInt32(dr["referencia_id"]),
                                    }
                                }
                            );
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar los dominios del rol: " + ex.Message);
            }
            return lst;
        }

        public List<DOMINIO> ObtenerDominiosNoAsignados(int IdRol, int IdDominio)
        {
            List<DOMINIO> lst = new List<DOMINIO>();

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {

                    SqlCommand cmd = new SqlCommand("usp_LeerDominiosNoAsignadosPorRol", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("IdRol", IdRol);
                    cmd.Parameters.AddWithValue("IdTipoDominio", IdDominio);

                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lst.Add(
                                new DOMINIO
                                {
                                    id_dominio = Convert.ToInt32(dr["id_dominio"]),
                                    descripcion_dominio = dr["descripcion_dominio"].ToString(),
                                    referencia_id = Convert.ToInt32(dr["referencia_id"]),
                                }
                            );
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar los dominios no asignados: " + ex.Message);
            }
            return lst;
        }

        public int AsignarDominio(int IdRol, int IdDominio)
        {
            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_AsignarDominio", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("IdRol", IdRol);
                    cmd.Parameters.AddWithValue("IdDominio", IdDominio);

                    conexion.Open();
                    return Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al asignar el dominio: " + ex.Message);
            }
        }

        public int ReemplazarDominiosRol(int IdRol, List<int> IdsDominios, int? IdTipoDominio = null, string TipoDominio = null)
{
    try
    {
        using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
        {
            SqlCommand cmd = new SqlCommand("usp_ReemplazarDominiosRol", conexion);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("IdRol", IdRol);
            
            // Convertir lista a string separado por comas
            string idsDominiosString = IdsDominios != null && IdsDominios.Any() 
                ? string.Join(",", IdsDominios) 
                : null;
                
            cmd.Parameters.AddWithValue("IdsDominios", idsDominiosString ?? (object)DBNull.Value);
            
            // Parámetros opcionales del tipo de dominio
            if (IdTipoDominio.HasValue)
                cmd.Parameters.AddWithValue("IdTipoDominio", IdTipoDominio.Value);
            else
                cmd.Parameters.AddWithValue("IdTipoDominio", DBNull.Value);
                
            if (!string.IsNullOrEmpty(TipoDominio))
                cmd.Parameters.AddWithValue("TipoDominio", TipoDominio);
            else
                cmd.Parameters.AddWithValue("TipoDominio", DBNull.Value);

            conexion.Open();
            return Convert.ToInt32(cmd.ExecuteScalar());
        }
    }
    catch (Exception ex)
    {
        throw new Exception("Error al reemplazar dominios del rol: " + ex.Message);
    }
}

        // Quitar dominio asignado
        public bool QuitarDominioAsignado(int IdDominio, out string mensaje)
        {
            bool resultado = false;
            mensaje = string.Empty;
            try
            {
                // Crear conexión
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    // Consulta SQL con parámetros
                    SqlCommand cmd = new SqlCommand("usp_QuitarDominioAsignado", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Agregar parámetro de entrada
                    cmd.Parameters.AddWithValue("IdDominio", IdDominio);

                    // Agregar parámetro de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Bit).Direction = ParameterDirection.Output;

                    // Abrir conexión
                    conexion.Open();
                    cmd.ExecuteNonQuery();

                    // Obtener valores de los parámetros de salida
                    resultado = cmd.Parameters["Resultado"].Value != DBNull.Value && Convert.ToBoolean(cmd.Parameters["Resultado"].Value);
                    mensaje = resultado ? "Dominio quitado correctamente" : "El dominio no existe";
                }
            }
            catch (Exception ex)
            {
                resultado = false;
                mensaje = "Error al quitar el dominio asignado a un rol: " + ex.Message;
            }
            return resultado;
        }
    }
}
