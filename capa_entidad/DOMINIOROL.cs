using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class DOMINIOROL
    {
        public int id_dominio_rol { get; set; }
        public int fk_rol { get; set; }
        public int fk_dominio { get; set; }
        public bool estado { get; set; }
        public DateTime fecha_registro { get; set; }
        public virtual DOMINIO Dominio { get; set; }
        public virtual ROL Rol { get; set; }
}
}
