using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class CARRERA
    {
        public int id_carrera { get; set; }
        public string nombre { get; set; }
        public string codigo { get; set; }
        public bool estado { get; set; }
        public DateTime fecha_registro { get; set; }
    }
}
