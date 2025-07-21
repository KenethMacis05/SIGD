using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_PlanClasesDiario
    {
        CD_PlanClasesDiario CD_PlanClasesDiario = new CD_PlanClasesDiario();
        
        public void CrearPlanClaseDiario(capa_entidad.PLANCLASESDIARIO plan)
        {
        }
        
        public List<PLANCLASESDIARIO> ListarPlanesClases(int id_usuario, out int resultado, out string mensaje)
        {
            return CD_PlanClasesDiario.ListarPlanClasesDiario(id_usuario, out resultado, out mensaje);
        }
        public PLANCLASESDIARIO ObtenerPlanDiarioPorId(int id_plan_diario, int id_usuario)
        {
            return CD_PlanClasesDiario.ObtenerPlanDiarioPorId(id_plan_diario, id_usuario);
        }

        public bool EliminarPlanClasesDiario(int id_plan_diario, out string mensaje)
        {
            return CD_PlanClasesDiario.EliminarPlanClasesDiario(id_plan_diario, out mensaje);
        }

        public bool EditarPlanDiario(PLANCLASESDIARIO model, out string mensaje)
        {
            throw new NotImplementedException();
        }
    }
}
