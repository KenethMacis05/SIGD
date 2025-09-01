using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_Carrera
    {
        private CD_Carrera CD_Carrera = new CD_Carrera();

        //Listar carreras
        public List<CARRERA> Listar()
        {
            return CD_Carrera.Listar();
        }
    }
}
