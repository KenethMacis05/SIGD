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
        public string asignatura { get; set; }
        public string descripcion { get; set; }
    }
}
