using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using capa_datos;
using capa_entidad;

namespace capa_negocio
{
    public class CN_Archivo
    {
        private CD_Archivo CD_Archivo = new CD_Archivo();

        public List<ARCHIVO> ListarArchivosRecientes(int id_usuario, out int resultado, out string mensaje)
        {
            return CD_Archivo.ListarArchivosRecientes(id_usuario, out resultado, out mensaje);
        }

        public List<ARCHIVO> ListarArchivos(int id_usuario, out int resultado, out string mensaje)
        {
            return CD_Archivo.ListarArchivos(id_usuario, out resultado, out mensaje);
        }

        public List<ARCHIVO> BuscarArchivos(string nombre, int id_usuario, out int resultado, out string mensaje)
        {
            if (string.IsNullOrEmpty(nombre))
            {
                mensaje = "Por favor, ingrese el nombre del archivo";
            }
            return CD_Archivo.BuscarArchivos(nombre, id_usuario, out resultado, out mensaje);
        }

        public List<ARCHIVO> ListarArchivosPorCarpeta(int idCarpeta, out int resultado, out string mensaje)
        {
            if (idCarpeta == 0)
            {
                mensaje = "Por favor, seleccione una carpeta";
                resultado = 0;
                return null;
            }

            return CD_Archivo.ListarArchivosPorCarpeta(idCarpeta, out resultado, out mensaje);
        }

        public List<ARCHIVO> ListarArchivosElimandos(int id_usuario, out int resultado, out string mensaje)
        {
            return CD_Archivo.ListarArchivosEliminados(id_usuario, out resultado, out mensaje);
        }

        public List<ARCHIVO> ListarArchivosCompartidosConmigo(int id_usuario, out int resultado, out string mensaje)
        {
            return CD_Archivo.ObtenerArchivosCompartidosConmigo(id_usuario, out resultado, out mensaje);
        }

        public int SubirArchivo(ARCHIVO archivo, out string mensaje)
        {
            mensaje = string.Empty;
            if (string.IsNullOrEmpty(archivo.nombre))
            {
                mensaje = "Por favor, ingrese el nombre del archivo";
            }

            return CD_Archivo.SubirArchivo(archivo, out mensaje);
        }

        public bool RenombrarArchivo(int idArchivo, string nuevoNombre, out string mensaje)
        {
            mensaje = string.Empty;
            return CD_Archivo.RenombrarArchivo(idArchivo, nuevoNombre, out mensaje);
        }

        public int Eliminar(int id_archivo, out string mensaje)
        {
            bool eliminado = CD_Archivo.EliminarArchivo(id_archivo, out mensaje);
            return eliminado ? 1 : 0;
        }

        public int EliminarDefinitivamente(int id_archivo, int id_usuario, out string mensaje)
        {
            bool eliminado = CD_Archivo.EliminarArchivoDefinitivamente(id_archivo, id_usuario, out mensaje);
            return eliminado ? 1 : 0;
        }

        public bool ObtenerRutaArchivoPorId(int idArchivo, out string ruta, out string mensaje)
        {
            return CD_Archivo.ObtenerRutaArchivoPorId(idArchivo, out ruta, out mensaje);
        }

        public bool CompartirArchivo(int idArchivo, int idUsuarioPropietario, int idUsuarioDestino, string permisos, out string mensaje)
        {
            //if (string.IsNullOrEmpty(correoDestino))
            //{
            //    mensaje = "Debe especificar un correo electrónico válido para compartir la carpeta.";
            //    return false;
            //}

            if (permisos != "lectura" && permisos != "edicion")
            {
                mensaje = "Permisos no válidos";
                return false;
            }

            return CD_Archivo.CompartirArchivo(idArchivo, idUsuarioPropietario, idUsuarioDestino, permisos, out mensaje);
        }
    }
}
