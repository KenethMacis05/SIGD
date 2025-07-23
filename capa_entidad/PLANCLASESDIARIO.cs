using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace capa_entidad
{
    public class PLANCLASESDIARIO
    {
        public int id_plan_diario { get; set; }
        public string codigo { get; set; }
        public string nombre { get; set; }
        public DateTime fecha_registro { get; set; }

        public bool estado { get; set; }
        // Datos generales
        public string area_conocimiento { get; set; }
        public string departamento { get; set; }
        public string carrera { get; set; }

        [AllowHtml]
        public string ejes { get; set; }
        public string asignatura { get; set; }
        public int fk_profesor { get; set; }
        public int fk_periodo { get; set; }
        [AllowHtml]
        public string competencias { get; set; }
        [AllowHtml]
        public string BOA { get; set; }
        public DateTime fecha_inicio { get; set; }
        public DateTime fecha_fin { get; set; }

        // Aprendizaje
        [AllowHtml]
        public string objetivo_aprendizaje { get; set; }
        [AllowHtml]
        public string tema_contenido { get; set; }
        [AllowHtml]
        public string indicador_logro { get; set; }

        // Tareas o actividades de aprendizaje
        [AllowHtml]
        public string tareas_iniciales { get; set; }
        [AllowHtml]
        public string tareas_desarrollo { get; set; }
        [AllowHtml]
        public string tareas_sintesis { get; set; }

        // Evaluación de los aprendizajes
        [AllowHtml]
        public string tipo_evaluacion { get; set; }
        [AllowHtml]
        public string estrategia_evaluacion { get; set; }
        [AllowHtml]
        public string instrumento_evaluacion { get; set; }
        [AllowHtml]
        public string evidencias_aprendizaje { get; set; }
        [AllowHtml]
        public string criterios_aprendizaje { get; set; }
        [AllowHtml]
        public string indicadores_aprendizaje { get; set; }
        [AllowHtml]
        public string nivel_aprendizaje { get; set; }
        public string profesor { get; set; }
        public string periodo { get; set; }
    }
}
