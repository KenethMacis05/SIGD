using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_Controlador
    {
        private CD_Controller CD_Controlador = new CD_Controller();

        //Listar usuarios
        public List<CONTROLLER> Listar()
        {
            return CD_Controlador.Listar();
        }
    }
}
