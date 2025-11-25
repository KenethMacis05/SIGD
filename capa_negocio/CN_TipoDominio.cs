using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_TipoDominio
    {
        private CD_TipoDominio CD_TipoDominio = new CD_TipoDominio();

        //Listar tipos de dominio
        public List<TIPODOMINIO> Listar()
        {
            return CD_TipoDominio.Listar();
        }

    }
}
