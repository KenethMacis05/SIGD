using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class DESCRIPCIONASIGNATURAMATRIZ
    {
        public int id_descripcion { get; set; }
        public int fk_matriz_asignatura { get; set; }
        public string descripcion { get; set; }
        public string accion_integradora { get; set; }
        public string tipo_evaluacion { get; set; }
        public DateTime fecha_registro { get; set; }
    }
}
