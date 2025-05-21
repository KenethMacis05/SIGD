using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using capa_entidad;
using Newtonsoft.Json;

namespace capa_datos
{
    public class CD_Menu
    {
        public List<MENU> ObtenerMenuPorUsuario(int IdUsuario)
        {
            List<MENU> lista = new List<MENU>();

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerMenuPorUsuario", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("IdUsuario", IdUsuario);

                    conexion.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            var menu = new MENU()
                            {
                                id_menu = Convert.ToInt32(dr["id_menu"]),
                                nombre = dr["nombre"].ToString(),
                                icono = dr["icono"].ToString(),
                                orden = dr["orden"] != DBNull.Value ? Convert.ToInt32(dr["orden"]) : 0,
                            };

                            // Si tiene controlador asociado, cargar sus datos
                            if (dr["controlador"] != DBNull.Value)
                            {
                                menu.Controller = new CONTROLLER()
                                {
                                    controlador = dr["controlador"].ToString(),
                                    accion = dr["vista"].ToString() // Nota: vista = accion en el SP
                                };
                            }

                            lista.Add(menu);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lista = new List<MENU>();
                throw new Exception("Error al obtener menú del usuario: " + ex.Message);
            }

            return lista;
        }
        
        public List<MENU> ObtenerMenusPorRol(int IdRol)
        {
            List<MENU> lista = new List<MENU>();

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerMenuPorRol", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("IdRol", IdRol);

                    conexion.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            var menu = new MENU()
                            {
                                id_menu_rol = Convert.ToInt32(dr["id_menu_rol"]),
                                id_menu = Convert.ToInt32(dr["id_menu"]),
                                fk_controlador = Convert.ToInt32(dr["fk_controlador"]),
                                nombre = dr["nombre"].ToString(),
                                icono = dr["icono"].ToString(),
                                orden = dr["orden"] != DBNull.Value ? Convert.ToInt32(dr["orden"]) : 0,
                            };

                            // Si tiene controlador asociado, cargar sus datos
                            if (dr["controlador"] != DBNull.Value)
                            {
                                menu.Controller = new CONTROLLER()
                                {
                                    controlador = dr["controlador"].ToString(),
                                    accion = dr["vista"].ToString()
                                };
                            }

                            lista.Add(menu);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lista = new List<MENU>();
                throw new Exception("Error al obtener menús del rol: " + ex.Message);
            }

            return lista;
        }

        // Obtener menus no asignados
        public List<MENU> ObtenerMenusNoAsignadosPorRol(int IdRol)
        {
            List<MENU> lista = new List<MENU>();

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerMenusNoAsignadosPorRol", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("IdRol", IdRol);

                    conexion.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            var menu = new MENU()
                            {
                                id_menu = Convert.ToInt32(dr["id_menu"]),
                                nombre = dr["nombre"].ToString(),
                                icono = dr["icono"].ToString(),
                                orden = dr["orden"] != DBNull.Value ? Convert.ToInt32(dr["orden"]) : 0,
                            };

                            // Si tiene controlador asociado, cargar sus datos
                            if (dr["controlador"] != DBNull.Value)
                            {
                                menu.Controller = new CONTROLLER()
                                {
                                    controlador = dr["controlador"].ToString(),
                                    accion = dr["vista"].ToString()
                                };
                            }

                            lista.Add(menu);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lista = new List<MENU>();
                throw new Exception("Error al obtener menús no asignados del rol: " + ex.Message);
            }

            return lista;
        }

        // Asignar menus al rol
        public int AsignarMenusPorRol(int IdRol, int IdMenu)
        {
            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_AsignarMenus", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("IdRol", IdRol);
                    cmd.Parameters.AddWithValue("IdMenu", IdMenu);

                    conexion.Open();
                    return Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al asignar menus: " + ex.Message);
            }
        }

        // Eliminar menu del rol
        public bool EliminarMenuDelRol(int IdMenuRol, out string mensaje)
        {
            bool resultado = false;
            mensaje = string.Empty;
            try
            {                
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {                 
                    SqlCommand cmd = new SqlCommand("usp_EliminarMenuDelRol", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    
                    cmd.Parameters.AddWithValue("IdMenuRol", IdMenuRol);                    
                    cmd.Parameters.Add("Resultado", SqlDbType.Bit).Direction = ParameterDirection.Output;
                    
                    conexion.Open();
                    cmd.ExecuteNonQuery();

                    resultado = cmd.Parameters["Resultado"].Value != DBNull.Value && Convert.ToBoolean(cmd.Parameters["Resultado"].Value);
                    mensaje = resultado ? "Menú eliminado correctamente" : "El menú no existe";
                }
            }
            catch (Exception ex)
            {
                resultado = false;
                mensaje = "Error al eliminar el menú: " + ex.Message;
            }
            return resultado;
        }
    }
}
