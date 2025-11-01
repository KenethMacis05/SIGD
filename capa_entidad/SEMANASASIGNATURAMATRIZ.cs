using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class SEMANASASIGNATURAMATRIZ
    {
        public int id_semana { get; set; }
        public int fk_matriz_asignatura { get; set; }
        public string numero_semana { get; set; }
        public string descripcion { get; set; }
        public DateTime fecha_inicio { get; set; }
        public DateTime fecha_fin { get; set; }
        public string tipo_semana { get; set; }
        public string estado { get; set; }
        public DateTime fecha_registro { get; set; }
    }
}
