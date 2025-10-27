using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_entidad
{
    public class MATRIZASIGNATURA
    {
        public int id_matriz_asignatura { get; set; }
        [NotMapped] // Para Entity Framework, no mapear a la base de datos
        public string id_matriz_asignatura_encriptado { get; set; }
        public int fk_matriz_integracion { get; set; }
        [NotMapped] // Para Entity Framework, no mapear a la base de datos
        public string fk_matriz_integracion_encriptado { get; set; }
        public int fk_asignatura { get; set; }
        public int fk_profesor_propietario { get; set; }
        public int fk_profesor_asignado { get; set; }
        public string estado { get; set; }
        public DateTime fecha_registro { get; set; }
        public string codigo_asignatura { get; set; }
        public string nombre_asignatura { get; set; }
        public string nombre_profesor { get; set; }
        public string correo_profesor { get; set; }
        public int semanas_finalizadas { get; set; }
        public int total_semanas { get; set; }
        public string codigo_matriz { get; set; }
        public string nombre_matriz { get; set; }
    }
}
