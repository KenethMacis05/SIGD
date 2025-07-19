using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class COMPONENTECURRICULAR
    {
        public int id_componente_curricular { get; set; }
        public int fk_asignatura { get; set; }
        public int fk_carrera { get; set; }
        public int fk_departamento { get; set; }
        public int fk_area_conocimiento { get; set; }
    }
}
