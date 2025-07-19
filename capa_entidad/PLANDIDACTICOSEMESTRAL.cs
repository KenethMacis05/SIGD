using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class PLANDIDACTICOSEMESTRAL
    {
        public int id_plan_didactico_semestral { get; set; }
        public int fk_profesor { get; set; }
        public string codigo { get; set; }
        public string nombre { get; set; }
        public bool estado { get; set; }
        public string areaConocimiento { get; set; }
        public string departamento { get; set; }
        public string carrera { get; set; }
        public int fk_anio_semestre { get; set; }
        public DateTime fecha_inicio { get; set; }
        public DateTime fecha_fin { get; set; }
        public string eje_disiplinar { get; set; }
        public string asignatura { get; set; }
        public string curriculum { get; set; }
        public string competencias { get; set; }
        public string objetivo_integrador { get; set; }
        public string eje_transversal { get; set; }
        public string bibliografia { get; set; }
        public DateTime fecha_registro { get; set; }
    }
}
