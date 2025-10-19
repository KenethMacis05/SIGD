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
    public class CD_MatrizIntegracionComponentes
    {
        // 1. Listar matriz de integración de componentes por usuario
        public List<MATRIZINTEGRACIONCOMPONENTES> Listar(int id_usuario, out int resultado, out string mensaje)
        {
            List<MATRIZINTEGRACIONCOMPONENTES> lst = new List<MATRIZINTEGRACIONCOMPONENTES>();
            resultado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_LeerMatrizIntegracion", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("IdUsuario", id_usuario);
                    
                    // Parámetros de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;

                    // Abrir conexión
                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lst.Add(
                                new MATRIZINTEGRACIONCOMPONENTES
                                {
                                    id_matriz_integracion = Convert.ToInt32(dr["id_matriz_integracion"]),
                                    codigo = dr["codigo"].ToString(),
                                    nombre = dr["nombre"].ToString(),
                                    area = dr["area_conocimiento"].ToString(),
                                    departamento = dr["departamento"].ToString(),
                                    carrera = dr["carrera"].ToString(),
                                    asignatura = dr["asignatura"].ToString(),
                                    usuario = dr["usuario"].ToString(),
                                    periodo = Convert.ToInt32(dr["periodo"]),
                                    estado = Convert.ToBoolean(dr["estado"]),
                                    fecha_registro = Convert.ToDateTime(dr["fecha_registro"]),
                                }
                            );
                        }
                    }

                    resultado = Convert.ToInt32(cmd.Parameters["Resultado"].Value);
                    mensaje = cmd.Parameters["Mensaje"].Value.ToString();
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar la matriz de integración de componentes por usuario: " + ex.Message);
            }
            return lst;
        }

        // 2. Crerar matriz de integración de componentes
        public int RegistrarMatrizIntegracion(MATRIZINTEGRACIONCOMPONENTES matriz, out string mensaje)
        {
            int idautogenerado = 0;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_CrearMatrizIntegracion", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parámetros de entrada
                    cmd.Parameters.AddWithValue("Nombre", matriz.nombre);
                    cmd.Parameters.AddWithValue("FKArea", matriz.fk_area);
                    cmd.Parameters.AddWithValue("FKDepartamento", matriz.fk_departamento);
                    cmd.Parameters.AddWithValue("FKCarrera", matriz.fk_carrera);
                    cmd.Parameters.AddWithValue("FKAsignatura", matriz.fk_asignatura);
                    cmd.Parameters.AddWithValue("FKPeriodo", matriz.fk_periodo);
                    cmd.Parameters.AddWithValue("FKProfesor", matriz.fk_profesor);
                    cmd.Parameters.AddWithValue("Competencias", matriz.competencias);
                    cmd.Parameters.AddWithValue("ObjetivoAnio", matriz.objetivo_anio);
                    cmd.Parameters.AddWithValue("ObjetivoSemestre", matriz.objetivo_semestre);
                    cmd.Parameters.AddWithValue("ObjetivoIntegrador", matriz.objetivo_integrador);
                    cmd.Parameters.AddWithValue("EstrategiaIntegradora", matriz.estrategia_integradora);

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
                throw new Exception("Error al crear la matriz de integración de componentes: " + ex.Message);
            }

            return idautogenerado;
        }

        // 3. Actualizar matriz de integración de componentes
        public bool ActualizarMatrizIntegracion(MATRIZINTEGRACIONCOMPONENTES matriz, out string mensaje)
        {
            bool resultado = false;
            mensaje = string.Empty;
            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_ActualizarMatrizIntegracion", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    // Parámetros de entrada
                    cmd.Parameters.AddWithValue("IdMatriz", matriz.id_matriz_integracion);
                    cmd.Parameters.AddWithValue("Nombre", matriz.nombre);
                    cmd.Parameters.AddWithValue("FKArea", matriz.fk_area);
                    cmd.Parameters.AddWithValue("FKDepartamento", matriz.fk_departamento);
                    cmd.Parameters.AddWithValue("FKCarrera", matriz.fk_carrera);
                    cmd.Parameters.AddWithValue("FKAsignatura", matriz.fk_asignatura);
                    cmd.Parameters.AddWithValue("FKPeriodo", matriz.fk_periodo);
                    cmd.Parameters.AddWithValue("FKProfesor", matriz.fk_profesor);
                    cmd.Parameters.AddWithValue("Competencias", matriz.competencias);
                    cmd.Parameters.AddWithValue("ObjetivoAnio", matriz.objetivo_anio);
                    cmd.Parameters.AddWithValue("ObjetivoSemestre", matriz.objetivo_semestre);
                    cmd.Parameters.AddWithValue("ObjetivoIntegrador", matriz.objetivo_integrador);
                    cmd.Parameters.AddWithValue("EstrategiaIntegradora", matriz.estrategia_integradora);
                    
                    // Parámetros de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Bit).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;

                    // Abrir conexión
                    conexion.Open();

                    // Ejecutar comando
                    cmd.ExecuteNonQuery();

                    // Obtener valores de los parámetros de salida
                    resultado = cmd.Parameters["Resultado"].Value != DBNull.Value && Convert.ToBoolean(cmd.Parameters["Resultado"].Value);
                    mensaje = cmd.Parameters["Mensaje"].Value != DBNull.Value ? cmd.Parameters["Mensaje"].Value.ToString() : "Mensaje no disponible.";
                }
            }
            catch (Exception ex)
            {
                resultado = false;
                throw new Exception("Error al actualizar la matriz de integración de componentes: " + ex.Message);
            }
            return resultado;
        }

        // 4. Eliminar matriz de integración de componentes
        public bool EliminarMatrizIntegracion(int id_matriz, int id_usuario, out string mensaje)
        {
            bool resultado = false;
            mensaje = string.Empty;
            try
            {
                using (SqlConnection conexion = new SqlConnection(Conexion.conexion))
                {
                    SqlCommand cmd = new SqlCommand("usp_EliminarMatrizIntegracion", conexion);
                    cmd.CommandType = CommandType.StoredProcedure;
                    
                    // Parámetros de entrada
                    cmd.Parameters.AddWithValue("IdMatriz", id_matriz);
                    cmd.Parameters.AddWithValue("IdUsuario", id_usuario);

                    // Parámetros de salida
                    cmd.Parameters.Add("Resultado", SqlDbType.Bit).Direction = ParameterDirection.Output;

                    // Abrir conexión
                    conexion.Open();

                    // Ejecutar comando
                    cmd.ExecuteNonQuery();

                    // Obtener valores de los parámetros de salida
                    resultado = cmd.Parameters["Resultado"].Value != DBNull.Value && Convert.ToBoolean(cmd.Parameters["Resultado"].Value);
                    mensaje = resultado ? "Matriz de Integración de Componente eliminada correctamente" : "La Matriz de Integración no existe";
                }
            }
            catch (Exception ex)
            {
                resultado = false;
                throw new Exception("Error al eliminar la matriz de integración de componentes: " + ex.Message);
            }
            return resultado;
        }
    }
}
