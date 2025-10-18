using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class MATRIZASIGNATURA
    {
        public int id_matriz_asignatura { get; set; }
        public int fk_matriz_integracion { get; set; }
        public int fk_asignatura { get; set; }
        public int fk_profesor_asignado { get; set; }
        public bool estado { get; set; }
        public DateTime fecha_registro { get; set; }
    }
}
