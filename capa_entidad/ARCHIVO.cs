using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class ARCHIVO
    {
        public int id_archivo { get; set; }
        public string nombre { get; set; }
        public string tipo { get; set; }
        public int size { get; set; }
        public string ruta { get; set; }
        public DateTime fecha_subida { get; set; }
        public DateTime fecha_eliminacion { get; set; }
        public bool estado { get; set; }
        public int? id_carpeta { get; set; }
        public int? id_usuario { get; set; }
        public string nombre_carpeta { get; set; }
        public byte[] Contenido { get; set; }

        // Propiedades para compartir archivos

        public string propietario { get; set; }
        public string permisos { get; set; }
        public string correo { get; set; }
        public DateTime fecha_compartido { get; set; }
    }

    public class ARCHIVOCOMPARTIDO
    {
        public int IdArchivo;
        public string NombreArchivo;
        public string Ruta;
        public DateTime FechaRegistro;
        public string CorreoDestinatario;
        public string NombreDestinatario;
        public string Permisos;
        public DateTime FechaCompartido;
    }
}
