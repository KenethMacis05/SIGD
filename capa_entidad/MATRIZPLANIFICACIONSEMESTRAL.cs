using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class MATRIZPLANIFICACIONSEMESTRAL
    {
        public int id_matriz { get; set; }
        public int fk_plan_didactico_semestral { get; set; }
        public int numero_semana { get; set; }
        public string objetivo_aprendizaje { get; set; }
        public string contenidos_esenciales { get; set; }
        public string estrategias_aprendizaje { get; set; }
        public string estrategias_evaluacion { get; set; }
        public string tipo_evaluacion { get; set; }
        public string instrumento_evaluacion { get; set; }
        public string evidencias_aprendizaje { get; set; }
    }
}
