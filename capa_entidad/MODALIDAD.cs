using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class MODALIDAD
    {
        public int id_modalidad { get; set; }
        public string nombre { get; set; }
        public bool estado { get; set; } = true;
        public DateTime fecha_registro { get; set; } = DateTime.Now;
    }
}
