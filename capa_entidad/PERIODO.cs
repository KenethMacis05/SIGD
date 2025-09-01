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
        public string anio { get; set; }
        public string semestre { get; set; }
        public bool estado { get; set; }
        public DateTime fecha_registro { get; set; }
    }
}
