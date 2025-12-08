using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_Reporte
    {
        CD_Reporte CD_Reporte = new CD_Reporte();

        public List<REPORTE> ListarPorDominios(int UsuarioId)
        {
            return CD_Reporte.ListarPorDominios(UsuarioId);
        }
    }
}
