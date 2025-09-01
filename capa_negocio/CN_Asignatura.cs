using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_Asignatura
    {
        private CD_Asignatura CD_Asignatura = new CD_Asignatura();

        //Listar asignaturas
        public List<ASIGNATURA> Listar()
        {
            return CD_Asignatura.Listar();
        }
    }
}
