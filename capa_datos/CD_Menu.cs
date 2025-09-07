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
                                orden = dr["orden"] != DBNull.Value ? dr["orden"].ToString() : "0"
                            };

                            // Si tiene controlador asociado, cargar sus datos
                            if (dr["controlador"] != DBNull.Value && dr["controlador"].ToString() != "NULL")
                            {
                                menu.Controller = new CONTROLLER()
                                {
                                    controlador = dr["controlador"].ToString(),
                                    accion = dr["vista"].ToString()
                                };
                            }
                            else
                            {
                                menu.Controller = new CONTROLLER()
                                {
                                    controlador = "#",
                                    accion = "#",
                                };
                            }

                            lista.Add(menu);
                        }
                    }
                }

                // Ordenar la lista por orden numérico
                lista = lista.OrderBy(m => decimal.Parse(m.orden)).ToList();

            }
            catch (Exception ex)
            {
                lista = new List<MENU>();
                throw new Exception("Error al obtener menú del usuario: " + ex.Message);
            }

            return lista;
        }

        public List<MENU> ObtenerTodosLosMenus()
        {
            List<MENU> lista = new List<MENU>();

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerTodosLosMenu", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

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
                                orden = dr["orden"] != DBNull.Value ? dr["orden"].ToString() : "0",
                                fk_controlador = dr["fk_controlador"] != DBNull.Value ? Convert.ToInt32(dr["fk_controlador"]) : (int?)null,
                            };

                            // Si tiene controlador asociado, cargar sus datos
                            if (dr["controlador"] != DBNull.Value && dr["controlador"].ToString() != "NULL")
                            {
                                menu.Controller = new CONTROLLER()
                                {
                                    controlador = dr["controlador"].ToString(),
                                    accion = dr["vista"].ToString()
                                };
                            }
                            else
                            {
                                menu.Controller = new CONTROLLER()
                                {
                                    controlador = "#",
                                    accion = "#",
                                };
                            }

                            lista.Add(menu);
                        }
                    }
                }

                // Ordenar la lista por orden numérico
                lista = lista.OrderBy(m => decimal.Parse(m.orden)).ToList();

            }
            catch (Exception ex)
            {
                lista = new List<MENU>();
                throw new Exception("Error al obtener todos los menú: " + ex.Message);
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
                                fk_controlador = dr["fk_controlador"] != DBNull.Value ? Convert.ToInt32(dr["fk_controlador"]) : (int?)null,
                                nombre = dr["nombre"].ToString(),
                                icono = dr["icono"].ToString(),
                                orden = dr["orden"] != DBNull.Value ? dr["orden"].ToString() : "0"
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
                                orden = dr["orden"] != DBNull.Value ? dr["orden"].ToString() : "0",
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

        public int Crear(MENU menu, out string mensaje)
        {
            int idautogenerado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_CrearMenu", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parámetros de entrada
                    cmd.Parameters.AddWithValue("Nombre", menu.nombre);

                    if (menu.fk_controlador.HasValue && menu.fk_controlador.Value != 0)
                    {
                        cmd.Parameters.AddWithValue("FkController", menu.fk_controlador.Value);
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("FkController", DBNull.Value);
                    }

                    cmd.Parameters.AddWithValue("Icono", menu.icono ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("Orden", menu.orden);

                    // Parámetros de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;

                    conexion.Open();
                    cmd.ExecuteNonQuery();

                    idautogenerado = Convert.ToInt32(cmd.Parameters["Resultado"].Value);
                    mensaje = cmd.Parameters["Mensaje"].Value.ToString();
                }
            }
            catch (Exception ex)
            {
                idautogenerado = 0;
                mensaje = "Error al registrar el menú: " + ex.Message;
            }

            return idautogenerado;
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
