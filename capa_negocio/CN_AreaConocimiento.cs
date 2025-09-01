using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_AreaConocimiento
    {
        private CD_AreaConocimiento CD_AreaConocimiento = new CD_AreaConocimiento();

        //Listar usuarios
        public List<AREACONOCIMIENTO> Listar()
        {
            return CD_AreaConocimiento.Listar();
        }
    }
}
