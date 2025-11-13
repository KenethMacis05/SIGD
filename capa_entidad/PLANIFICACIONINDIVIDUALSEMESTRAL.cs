using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace capa_entidad
{
    public class PLANIFICACIONINDIVIDUALSEMESTRAL
    {
        public int id_planificacion { get; set; }
        public int fk_plan_didactico { get; set; }	
        public int fk_contenido { get; set; }
        [AllowHtml]
        public string estrategias_aprendizaje { get; set; }
        [AllowHtml]
        public string estrategias_evaluacion { get; set; }
        [AllowHtml]
        public string tipo_evaluacion { get; set; }
        [AllowHtml]
        public string instrumento_evaluacion { get; set; }
        [AllowHtml]
        public string evidencias_aprendizaje { get; set; }
        public SEMANAS SEMANA { get; set; }
        public CONTENIDOS CONTENIDO { get; set; }
        public PLANDIDACTICOSEMESTRAL PLANSEMESTRAL { get; set; }
    }
}
