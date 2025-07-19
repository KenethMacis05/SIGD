using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class ASIGNATURA
    {
        public int id_asignatura { get; set; }
        public string nombre { get; set; }
        public string codigo { get; set; }
        public bool estado { get; set; }
        public DateTime fecha_registro { get; set; }
    }
}