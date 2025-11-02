using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_Modalidad
    {
        private CD_Modalidad CD_Modalidad = new CD_Modalidad();

        //Listar área de conocimiento
        public List<MODALIDAD> Listar()
        {
            return CD_Modalidad.Listar();
        }

    }
}
