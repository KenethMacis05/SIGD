using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class CONTENIDOS
    {
        // Datos de la tabla CONTENIDOS
        public int id_contenido { get; set; }
        public int fk_matriz_asignatura { get; set; }
        public int fk_semana { get; set; }
        public string contenido { get; set; }
        public string estado { get; set; }
        public DateTime fecha_registro { get; set; }

        //Datos adicionales para consultas
        public int numero_semana { get; set; }
        public string descripcion_semana { get; set; }
        public DateTime fecha_inicio { get; set; }
        public DateTime fecha_fin { get; set; }
        public string tipo_semana { get; set; }
        public string asignatura { get; set; }
        public string codigo_asignatura { get; set; }
        public string profesor { get; set; }
    }
}
