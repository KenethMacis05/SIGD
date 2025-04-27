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
        public bool estado { get; set; }
        public int id_carpeta { get; set; }
        public string nombre_carpeta { get; set; }
        public byte[] Contenido { get; set; }
    }
}
