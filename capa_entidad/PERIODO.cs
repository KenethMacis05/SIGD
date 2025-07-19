using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class PERIODO
    {
        public int id_periodo { get; set; }
        public int anio { get; set; }
        public int semestre { get; set; }
        public bool estado { get; set; }
        public DateTime fecha_registro { get; set; }
    }
}
