using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_PlanSemestral
    {
        CD_PlanSemestral CD_PlanSemestral = new CD_PlanSemestral();
        CN_Recursos CN_Recursos = new CN_Recursos();

        public List<PLANDIDACTICOSEMESTRAL> ListarDatosGenerales(int id_usuario, out int resultado, out string mensaje)
        {
            var planesSemestrales = CD_PlanSemestral.ListarDatosGenerales(id_usuario, out resultado, out mensaje);

            // Solo agregar la propiedad encriptada a cada objeto existente
            foreach (var planSemestral in planesSemestrales)
            {
                planSemestral.id_encriptado = CN_Recursos.EncryptValue(planSemestral.id_plan_didactico.ToString());
            }

            return planesSemestrales;
        }

        public PLANDIDACTICOSEMESTRAL ObtenerPlanSemestralPorId(string idEncriptado, int id_usuario, out string mensaje)
        {
            int id = Convert.ToInt32(new CN_Recursos().DecryptValue(idEncriptado));
            int resultado = 0;

            var planSemestral = CD_PlanSemestral.ObtenerPlanSemestralPorId(id, id_usuario, out resultado, out mensaje);

            planSemestral.id_encriptado = CN_Recursos.EncryptValue(planSemestral.id_plan_didactico.ToString());

            return planSemestral;
        }
    }
}
