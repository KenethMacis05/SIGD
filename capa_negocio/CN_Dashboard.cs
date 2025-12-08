using capa_datos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_Dashboard
    {
        CD_Dashboard CD_Dashboard = new CD_Dashboard();

        public int ContarMatricesAsignaturasPendientes(int idProfesor)
        {
            return CD_Dashboard.ContarMatricesAsignaturasPendientes(idProfesor);
        }

        public string ObtenerAlmacenamientoUsuario(int idUsuario)
        {
            return CD_Dashboard.ObtenerAlmacenamientoUsuario(idUsuario);
        }

        public int ContarArchivosCompartidosPorMi (int idUsuario)
        {
            return CD_Dashboard.ContarArchivosCompartidosPorMi(idUsuario);
        }

        public decimal ObtenerAvanceGlobal (int idProfesor)
        {
            return CD_Dashboard.ObtenerAvanceGlobal(idProfesor);
        }

        public int ObtenerContenidosPendientesUrgentes (int idProfesor)
        {
            return CD_Dashboard.ObtenerContenidosPendientesUrgentes(idProfesor);
        }

        public List<ProgresoSemanal> ObtenerProgresoSemanal(int idProfesor, int semanasAtras = 8)
        {
            return CD_Dashboard.ObtenerProgresoSemanal(idProfesor, semanasAtras);
        }
    }
}
