using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace capa_entidad
{
    public class PLANCLASESDIARIO
    {
        // 1. Datos del plan diario
        public int id_plan_diario { get; set; }
        [NotMapped]
        public string id_plan_diario_encriptado { get; set; }
        public string codigo { get; set; }
        public string nombre { get; set; }
        public int fk_plan_didactico { get; set; }
        [NotMapped]
        public string id_encriptado_plan_didactico { get; set; }
        public int fk_tema { get; set; }
        public int fk_plan_individual { get; set; }
        [AllowHtml]
        public string ejes { get; set; }
        [AllowHtml]
        public string competencias_genericas { get; set; }
        [AllowHtml]
        public string competencias_especificas { get; set; }
        [AllowHtml]
        public string BOA { get; set; }
        public DateTime fecha_inicio { get; set; }
        public DateTime fecha_fin { get; set; }
        [AllowHtml]
        public string objetivo_aprendizaje { get; set; }
        [AllowHtml]
        public string indicador_logro { get; set; }
        // Tareas o actividades de aprendizaje
        [AllowHtml]
        public string tareas_iniciales { get; set; }
        [AllowHtml]
        public string tareas_desarrollo { get; set; }
        [AllowHtml]
        public string tareas_sintesis { get; set; }
        
        // 2. Datos generales
        public string area_conocimiento { get; set; }
        public string departamento { get; set; }
        public string carrera { get; set; }
        public string asignatura { get; set; }
        public string periodo { get; set; }
        public string profesor { get; set; }

        // 3. Tema y contenido (s)
        public string tema { get; set; }
        [AllowHtml]
        public string contenido { get; set; }

        // 4. Evaluación de los aprendizajes
        [AllowHtml]
        public string tipo_evaluacion { get; set; }
        [AllowHtml]
        public string estrategias_evaluacion { get; set; }
        [AllowHtml]
        public string instrumento_evaluacion { get; set; }
        [AllowHtml]
        public string evidencias_aprendizaje { get; set; }
        
        public bool estado { get; set; }
        public DateTime fecha_registro { get; set; }
    }
}
