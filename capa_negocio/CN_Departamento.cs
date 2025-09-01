using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_Departamento
    {
        private CD_Departamento CD_Departamento = new CD_Departamento();

        //Listar departamentos
        public List<DEPARTAMENTO> Listar()
        {
            return CD_Departamento.Listar();
        }
    }
}
