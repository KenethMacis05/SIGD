using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace capa_negocio
{
    public class CN_PlanClasesDiario
    {
        CD_PlanClasesDiario CD_PlanClasesDiario = new CD_PlanClasesDiario();
        
        public void Crear(capa_entidad.PLANCLASESDIARIO plan)
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

        public int Eliminar(int id_plan, int id_usuario, out string mensaje)
        {
            bool eliminado = CD_PlanClasesDiario.EliminarPlanClasesDiario(id_plan, id_usuario, out mensaje);
            return eliminado ? 1 : 0;
        }

        public int Registra(PLANCLASESDIARIO plan, out string mensaje)
        {
            mensaje = string.Empty;

            // Validación de campos obligatorios
            if (string.IsNullOrEmpty(plan.nombre) ||
                string.IsNullOrEmpty(plan.codigo))
            {
                mensaje = "Por favor, complete todos los campos obligatorios.";
                return 0;
            }

            if (plan.fk_profesor == 0)
            {
                mensaje = "Por favor, seleccione un profesor.";
                return 0;
            }

            return CD_PlanClasesDiario.RegistrarPlanClasesDiario(plan, out mensaje);
        }

        public int Editar(PLANCLASESDIARIO plan, out string mensaje)
        {
            mensaje = string.Empty;

            if (string.IsNullOrEmpty(plan.nombre) ||
                string.IsNullOrEmpty(plan.codigo))
            {
                mensaje = "Por favor, complete todos los campos.";
                return 0;
            }

            if (plan.fk_profesor == 0)
            {
                mensaje = "Por favor, seleccione un profesor.";
                return 0;
            }

            bool actualizado = CD_PlanClasesDiario.ActualizarPlanClasesDiario(plan, out mensaje);
            return actualizado ? 1 : 0;
        }
    }
}
