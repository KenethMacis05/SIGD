using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class DOMINIO
    {
        public int id_dominio { get; set; }
        public int fk_tipo_dominio { get; set; }
        public string descripcion_dominio { get; set; }
        public string codigo { get; set; }
        public int referencia_id { get; set; }
        public bool estado { get; set; }
        public DateTime fecha_registro { get; set; }
        public virtual TIPODOMINIO TipoDominio { get; set; }
    }
}
