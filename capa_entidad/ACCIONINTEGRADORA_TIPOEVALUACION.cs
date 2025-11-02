using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class ACCIONINTEGRADORA_TIPOEVALUACION
    {
        public int id_accion_tipo { get; set; }
        [NotMapped] // Para Entity Framework, no mapear a la base de datos
        public string id_accion_tipo_encriptado { get; set; }
        public int fk_matriz_integracion { get; set; }
        [NotMapped] // Para Entity Framework, no mapear a la base de datos
        public string fk_matriz_integracion_encriptado { get; set; }
        public string numero_semana { get; set; }
        public string accion_integradora { get; set; }
        public string tipo_evaluacion { get; set; }
        public DateTime fecha_registro { get; set; } = DateTime.Now;
        public string nombre_matriz { get; set; }
        public string codigo_matriz { get; set; }
        public string estado { get; set; }
    }
}
