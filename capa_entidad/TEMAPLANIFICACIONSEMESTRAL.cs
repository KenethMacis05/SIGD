using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class TEMAPLANIFICACIONSEMESTRAL
    {
        public int id_tema { get; set; }
        public int fk_plan_didactico { get; set; }
        public string tema { get; set; }
        public int horas_teoricas { get; set; }
        public int horas_laboratorio { get; set; }
        public int horas_practicas { get; set; }
        public int horas_investigacion { get; set; }
        public int P_LAB_INV { get; set; }
        public int creditos { get; set; }
        public int numero_tema { get; set; }
    }
}
