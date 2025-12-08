using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;

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
        [AllowHtml]
        public string curriculum { get; set; }
        [AllowHtml]
        public string competencias_genericas { get; set; }
        [AllowHtml]
        public string competencias_especificas { get; set; }
        [AllowHtml]
        public string objetivos_aprendizaje { get; set; }
        [AllowHtml]
        public string objetivo_integrador { get; set; }
        [AllowHtml]
        public string competencia_generica { get; set; }
        [AllowHtml]
        public string tema_transversal { get; set; }
        [AllowHtml]
        public string valores_transversales { get; set; }
        [AllowHtml]
        public string estrategia_metodologica { get; set; }
        [AllowHtml]
        public string estrategia_evaluacion { get; set; }
        [AllowHtml]
        public string recursos { get; set; }
        [AllowHtml]
        public string bibliografia { get; set; }
        public DateTime fecha_registro { get; set; }
        public virtual MATRIZINTEGRACIONCOMPONENTES Matriz { get; set; }
        public bool estado { get; set; }
        public ASIGNATURA Asignatura { get; set; }
        [AllowHtml]
        public string eje_disciplinar { get; set; }
        public string estado_proceso_pds { get; set; }
        public string usuario_asignado { get; set; }
    }
}
