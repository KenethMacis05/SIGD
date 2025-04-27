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

        //public int SubirArchivo(ARCHIVO archivo, out string mensaje)
        //{
        //    mensaje = string.Empty;
        //    if (string.IsNullOrEmpty(archivo.nombre))
        //    {
        //        mensaje = "Por favor, ingrese el nombre del archivo";
        //    }

        //    bool resultado = CD_Archivo.SubirArchivo(archivo, out mensaje);
        //    return resultado ? 1 : 0;
        //}
    }
}
