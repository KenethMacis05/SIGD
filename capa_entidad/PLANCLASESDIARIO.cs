using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class PLANCLASESDIARIO
    {
        public int id_plan_diario { get; set; }
        public string codigo { get; set; }
        public string nombre { get; set; }
        public DateTime fecha_registro { get; set; }

        // Datos generales
        public string areaConocimiento { get; set; }
        public string departamento { get; set; }
        public string carrera { get; set; }
        public string ejes { get; set; }
        public string asignatura { get; set; }
        public int fk_profesor { get; set; }
        public int fk_periodo { get; set; }
        public string competencias { get; set; }
        public string BOA { get; set; }
        public DateTime fecha_inicio { get; set; }
        public DateTime fecha_fin { get; set; }

        // Aprendizaje
        public string objetivo_aprendizaje { get; set; }
        public string tema_contenido { get; set; }
        public string indicador_logro { get; set; }

        // Tareas o actividades de aprendizaje
        public string tareas_iniciales { get; set; }
        public string tareas_desarrollo { get; set; }
        public string tareas_sintesis { get; set; }

        // Evaluación de los aprendizajes
        public string tipo_evaluacion { get; set; }
        public string estrategia_evaluacion { get; set; }
        public string instrumento_evaluacion { get; set; }
        public string evidencias_aprendizaje { get; set; }
        public string criterios_aprendizaje { get; set; }
        public string indicadores_aprendizaje { get; set; }
        public string nivel_aprendizaje { get; set; }
    }
}
