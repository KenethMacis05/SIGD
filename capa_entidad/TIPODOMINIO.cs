using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class TIPODOMINIO
    {
        public int id_tipo_dominio { get; set; }
        public string descripcion_tipo_dominio { get; set; }
        public string nombre_procedimiento { get; set; }
        public bool estado { get; set; }
        public DateTime fecha_registro { get; set; }
    }
}
