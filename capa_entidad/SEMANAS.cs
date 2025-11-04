using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class SEMANAS
    {
        public int id_semana { get; set; }
        public int fk_matriz_integracion { get; set; }
        public string fk_matriz_integracion_encriptado { get; set; }
        public int numero_semana { get; set; }
        public string descripcion { get; set; }
        public DateTime fecha_inicio { get; set; }
        public DateTime fecha_fin { get; set; }
        public string tipo_semana { get; set; }
        public string estado { get; set; }
        public DateTime fecha_registro { get; set; }
    }
}
