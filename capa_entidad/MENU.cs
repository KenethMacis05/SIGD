using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class MENU
    {
        public int id_menu { get; set; }
        public int id_menu_rol { get; set; }
        public string nombre { get; set; }
        public int? fk_controlador { get; set; }
        public string icono { get; set; }
        public int orden { get; set; }
        public bool estado { get; set; } = true;
        public bool is_checked { get; set; }

        public DateTime fecha_registro { get; set; } = DateTime.Now;
        public virtual CONTROLLER Controller { get; set; }
    }
}
