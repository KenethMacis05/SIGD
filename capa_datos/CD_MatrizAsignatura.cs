﻿using capa_entidad;
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
        // En CD_MatrizAsignatura
        public List<MATRIZASIGNATURA> ListarAsignaturasPorMatriz(int fk_matriz_integracion, out int resultado, out string mensaje)
        {
            List<MATRIZASIGNATURA> lista = new List<MATRIZASIGNATURA>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerAsignaturasPorMatriz", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("FKMatrizIntegracion", fk_matriz_integracion);

                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(new MATRIZASIGNATURA()
                            {
                                id_matriz_asignatura = Convert.ToInt32(dr["id_matriz_asignatura"]),
                                fk_matriz_integracion = Convert.ToInt32(dr["fk_matriz_integracion"]),
                                fk_asignatura = Convert.ToInt32(dr["fk_asignatura"]),
                                codigo_asignatura = dr["codigo"].ToString(),
                                nombre_asignatura = dr["asignatura"].ToString(),
                                fk_profesor_asignado = Convert.ToInt32(dr["fk_profesor_asignado"]),
                                nombre_profesor = dr["profesor"].ToString(),
                                correo_profesor = dr["correo"].ToString(),
                                estado = dr["estado"].ToString(),
                                semanas_finalizadas = dr["semanas_finalizadas"] != DBNull.Value ? Convert.ToInt32(dr["semanas_finalizadas"]) : 0,
                                total_semanas = dr["total_semanas"] != DBNull.Value ? Convert.ToInt32(dr["total_semanas"]) : 0,
                                fecha_registro = Convert.ToDateTime(dr["fecha_registro"])
                            });
                        }
                    }

                    resultado = 1;
                    mensaje = "Asignaturas cargadas correctamente";
                }
            }
            catch (Exception ex)
            {
                resultado = 0;
                mensaje = "Error al listar las asignaturas: " + ex.Message;
            }

            return lista;
        }

        public List<MATRIZASIGNATURA> ListarAsignaturasPorProfesor(int profesorAsignado, out int resultado, out string mensaje)
        {
            List<MATRIZASIGNATURA> lista = new List<MATRIZASIGNATURA>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerAsignaturasPorProfesor", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@FKProfesorAsignado", profesorAsignado);

                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(new MATRIZASIGNATURA()
                            {
                                id_matriz_asignatura = Convert.ToInt32(dr["id_matriz_asignatura"]),
                                fk_matriz_integracion = Convert.ToInt32(dr["fk_matriz_integracion"]),
                                fk_asignatura = Convert.ToInt32(dr["fk_asignatura"]),
                                codigo_matriz = dr["codigo_matriz"].ToString(),
                                nombre_matriz = dr["nombre_matriz"].ToString(),
                                nombre_profesor = dr["profesor"].ToString(),
                                correo_profesor = dr["correo"].ToString(),
                                codigo_asignatura = dr["codigo"].ToString(),
                                nombre_asignatura = dr["asignatura"].ToString(),
                                fk_profesor_asignado = Convert.ToInt32(dr["fk_profesor_asignado"]),
                                estado = dr["estado"].ToString(),
                                semanas_finalizadas = dr["semanas_finalizadas"] != DBNull.Value ? Convert.ToInt32(dr["semanas_finalizadas"]) : 0,
                                total_semanas = dr["total_semanas"] != DBNull.Value ? Convert.ToInt32(dr["total_semanas"]) : 0,
                                fecha_registro = Convert.ToDateTime(dr["fecha_registro"])
                            });
                        }
                    }

                    resultado = 1;
                    mensaje = "Asignaturas cargadas correctamente";
                }
            }
            catch (Exception ex)
            {
                resultado = 0;
                mensaje = "Error al listar las asignaturas: " + ex.Message;
            }

            return lista;
        }
        
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
                mensaje = "Error al asignar la asignatura en la matriz: " + ex.Message;
            }

            return idautogenerado;
        }

        public int ActualizarMatrizAsignatura(MATRIZASIGNATURA matriz, out string mensaje)
        {
            int resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_ActualizarMatrizAsignatura", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parámetros de entrada
                    cmd.Parameters.AddWithValue("IdMatrizAsignatura", matriz.id_matriz_asignatura);

                    // Parámetros opcionales - usar DBNull.Value si no se proporcionan
                    if (matriz.fk_asignatura > 0)
                        cmd.Parameters.AddWithValue("FKAsignatura", matriz.fk_asignatura);
                    else
                        cmd.Parameters.AddWithValue("FKAsignatura", DBNull.Value);

                    if (matriz.fk_profesor_asignado > 0)
                        cmd.Parameters.AddWithValue("FKProfesorAsignado", matriz.fk_profesor_asignado);
                    else
                        cmd.Parameters.AddWithValue("FKProfesorAsignado", DBNull.Value);

                    // Parámetros de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 255).Direction = ParameterDirection.Output;

                    conexion.Open();
                    cmd.ExecuteNonQuery();

                    resultado = Convert.ToInt32(cmd.Parameters["Resultado"].Value);
                    mensaje = cmd.Parameters["Mensaje"].Value.ToString();
                }
            }
            catch (Exception ex)
            {
                resultado = 0;
                mensaje = "Error al actualizar la asignatura en la matriz: " + ex.Message;
            }

            return resultado;
        }

        public bool Eliminar(int id_matriz_asignatura, int fk_profesor_propietario, out string mensaje)
        {
            bool resultado = false;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_RemoverAsignaturaMatriz", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parámetros de entrada
                    cmd.Parameters.AddWithValue("IdMatrizAsignatura", id_matriz_asignatura);
                    cmd.Parameters.AddWithValue("FKProfesorPropietario", fk_profesor_propietario);

                    // Parámetro de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Bit).Direction = ParameterDirection.Output;

                    conexion.Open();
                    cmd.ExecuteNonQuery();

                    resultado = Convert.ToBoolean(cmd.Parameters["Resultado"].Value);

                    if (resultado)
                    {
                        mensaje = "Asignatura eliminada correctamente de la matriz";
                    }
                    else
                    {
                        mensaje = "No se pudo eliminar la asignatura. Verifique que exista.";
                    }
                }
            }
            catch (Exception ex)
            {
                resultado = false;
                mensaje = "Error al eliminar la asignatura de la matriz: " + ex.Message;
            }

            return resultado;
        }

        public MATRIZASIGNATURA ObtenerAsignaturaPorId(int id)
        {
            MATRIZASIGNATURA asignatura = new MATRIZASIGNATURA();

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_ObtenerAsignaturaAsignadaPorId", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("IdMatrizAsignatura", id);

                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            asignatura = new MATRIZASIGNATURA()
                            {
                                id_matriz_asignatura = Convert.ToInt32(dr["id_matriz_asignatura"]),
                                fk_matriz_integracion = Convert.ToInt32(dr["fk_matriz_integracion"]),
                                fk_asignatura = Convert.ToInt32(dr["fk_asignatura"]),
                                codigo_asignatura = dr["codigo"].ToString(),
                                nombre_asignatura = dr["asignatura"].ToString(),
                                fk_profesor_asignado = Convert.ToInt32(dr["fk_profesor_asignado"]),
                                nombre_profesor = dr["profesor"].ToString(),
                                correo_profesor = dr["correo"].ToString(),
                                estado = dr["estado"].ToString(),
                                fecha_registro = Convert.ToDateTime(dr["fecha_registro"])
                            };
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al obtener la asignatura por ID: " + ex.Message);
            }

            return asignatura;
        }
    }
}
