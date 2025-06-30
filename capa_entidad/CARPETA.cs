using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class CARPETA
    {
        public int id_carpeta { get; set; }
        public string nombre { get; set; }
        public string ruta { get; set; }
        public DateTime fecha_registro { get; set; }
        public DateTime fecha_eliminacion { get; set; }
        public bool estado { get; set; }
        public int fk_id_usuario { get; set; }
        public int? carpeta_padre { get; set; }
        public USUARIOS usuario { get; set; }
    }

    public class CARPETACOMPARTIDA
    {
        public int IdCarpeta { get; set; }
        public string NombreCarpeta { get; set; }
        public string Ruta { get; set; }
        public DateTime FechaRegistro { get; set; }

        // Para carpetas que yo compartí
        public string CorreoDestinatario { get; set; }
        public string NombreDestinatario { get; set; }

        // Para carpetas compartidas conmigo
        public string NombrePropietario { get; set; }

        public string Permisos { get; set; }
        public DateTime FechaCompartido { get; set; }
    }
}
