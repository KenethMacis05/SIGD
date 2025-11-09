using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class PLANDIDACTICOSEMESTRAL
    {
        public int id_plan_didactico { get; set; }
        public string id_encriptado { get; set; }
        public string codigo { get; set; }
        public string nombre { get; set; }
        public DateTime fecha_inicio { get; set; }
        public DateTime fecha_fin { get; set; }
        public int fk_matriz_asignatura { get; set; }
        public string curriculum { get; set; }
        public string competencias_generales { get; set; }
        public string competencias_especificas { get; set; }
        public string objetivos_aprendizaje { get; set; }
        public string objetivo_integrador { get; set; }
        public string estrategia_metodologica { get; set; }
        public string estrategia_evaluacion { get; set; }
        public string recursos { get; set; }
        public string bibliografia { get; set; }
        public DateTime fecha_registro { get; set; }
        public virtual MATRIZINTEGRACIONCOMPONENTES Matriz { get; set; }
        public bool estado { get; set; }
        public ASIGNATURA Asignatura { get; set; }
    }
}
