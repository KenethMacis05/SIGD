using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class TURNO
    {
        public int id_turno { get; set; }
        public string nombre { get; set; }
        public int fk_modalidad { get; set; }
        public bool estado { get; set; } = true;
        public DateTime fecha_registro { get; set; } = DateTime.Now;
        public MODALIDAD Modalidad { get; set; }
    }
}
