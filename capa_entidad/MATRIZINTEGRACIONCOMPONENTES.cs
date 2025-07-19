using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class MATRIZINTEGRACIONCOMPONENTES
    {
        public int id_matriz_integracion { get; set; }
        public string nombre { get; set; }
        public string codigo { get; set; }
        public int fk_profesor { get; set; }
        public bool estado { get; set; }
        public string competencias { get; set; }
        public string objetivo_anio { get; set; }
        public string objetivo_semestre { get; set; }
        public string objetivo_integrador { get; set; }
        public string accion_integradora { get; set; }
        public string tipo_evaluacion { get; set; }
        public DateTime fecha_registro { get; set; }
    }
}
