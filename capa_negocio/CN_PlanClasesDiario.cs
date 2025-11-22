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
        CN_Recursos CN_Recursos = new CN_Recursos();

        public List<PLANCLASESDIARIO> ListarPlanesClases(int id_usuario, out int resultado, out string mensaje)
        {
            var planes = CD_PlanClasesDiario.ListarPlanClasesDiario(id_usuario, out resultado, out mensaje);

            foreach (var plan in planes)
            {
                plan.id_encriptado_plan_didactico = CN_Recursos.EncryptValue(plan.fk_plan_didactico.ToString());
                plan.id_plan_diario_encriptado = CN_Recursos.EncryptValue(plan.id_plan_diario.ToString());
            }
            return planes;
        }

        public PLANCLASESDIARIO ObtenerPlanDiarioPorId(string idEncriptado, int id_usuario)
        {
            int id_plan_diario = Convert.ToInt32(new CN_Recursos().DecryptValue(idEncriptado));
            var planes = CD_PlanClasesDiario.ObtenerPlanDiarioPorId(id_plan_diario, id_usuario);

            foreach (var plan in new List<PLANCLASESDIARIO> { planes })
            {
                plan.id_encriptado_plan_didactico = CN_Recursos.EncryptValue(plan.fk_plan_didactico.ToString());
                plan.id_plan_diario_encriptado = CN_Recursos.EncryptValue(plan.id_plan_diario.ToString());
            }

            return planes;
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
            if (string.IsNullOrEmpty(plan.nombre))
            {
                mensaje = "Por favor, complete todos los campos obligatorios.";
                return 0;
            }

            return CD_PlanClasesDiario.RegistrarPlanClasesDiario(plan, out mensaje);
        }

        public int Editar(PLANCLASESDIARIO plan, out string mensaje)
        {
            mensaje = string.Empty;

            if (string.IsNullOrEmpty(plan.nombre))
            {
                mensaje = "Por favor, complete todos los campos.";
                return 0;
            }
            
            bool actualizado = CD_PlanClasesDiario.ActualizarPlanClasesDiario(plan, out mensaje);
            return actualizado ? 1 : 0;
        }
    }
}
