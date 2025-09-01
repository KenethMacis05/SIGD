using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_Periodo
    {
        private CD_Periodos CD_Periodos = new CD_Periodos();

        //Listar periodos
        public List<PERIODO> Listar()
        {
            return CD_Periodos.Listar();
        }
    }
}
