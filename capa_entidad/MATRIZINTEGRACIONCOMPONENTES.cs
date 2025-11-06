using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace capa_entidad
{
    public class MATRIZINTEGRACIONCOMPONENTES
    {
        public int id_matriz_integracion { get; set; }
        [NotMapped] // Para Entity Framework, no mapear a la base de datos
        public string id_encriptado { get; set; }
        public string nombre { get; set; }
        public string codigo { get; set; }
        public int fk_area { get; set; }
        public int fk_departamento { get; set; }
        public int fk_carrera { get; set; }
        public int fk_modalidad { get; set; }
        public int fk_asignatura { get; set; }
        public int fk_periodo { get; set; }
        public int fk_profesor { get; set; }
        [AllowHtml]
        public string objetivo_anio { get; set; }
        [AllowHtml]
        public string objetivo_semestre { get; set; }
        [AllowHtml]
        public string objetivo_integrador { get; set; }
        [AllowHtml]
        public string estrategia_integradora { get; set; }
        public bool estado { get; set; }
        public DateTime fecha_registro { get; set; }
        public string area { get; set; }
        public string departamento { get; set; }
        public string carrera { get; set; }
        public string modalidad { get; set; }
        public string asignatura { get; set; }
        public string usuario { get; set; }
        public string periodo { get; set; }
        [AllowHtml]
        public string competencias_genericas { get; set; }
        [AllowHtml]
        public string competencias_especificas { get; set; }
        public int numero_semanas { get; set; }
        public DateTime fecha_inicio { get; set; }
        public string estado_proceso { get; set; }
    }
}
