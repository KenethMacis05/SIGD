using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using capa_datos;
using capa_entidad;

namespace capa_negocio
{
    public class CN_PlanIndividual
    {
        CD_PlanificacionIndividual CD_PlanificacionIndividual = new CD_PlanificacionIndividual();
        CN_Recursos CN_Recursos = new CN_Recursos();

        public int Actualizar(PLANIFICACIONINDIVIDUALSEMESTRAL plan, out string mensaje)
        {
            mensaje = string.Empty;

            // Validaciones básicas
            if (plan == null)
            {
                mensaje = "Los datos de la asignatura no pueden ser nulos";
                return 0;
            }

            if (plan.id_planificacion <= 0)
            {
                mensaje = "Debe especificar un registro válido";
                return 0;
            }

            // Llamar al método de la capa de datos
            return CD_PlanificacionIndividual.Actualizar(plan, out mensaje);
        }

        public int Crear(PLANIFICACIONINDIVIDUALSEMESTRAL planIndividual, out string mensaje)
        {
            throw new NotImplementedException();
        }

        public List<PLANIFICACIONINDIVIDUALSEMESTRAL> Listar(string idEncriptado, out int resultado, out string mensaje)
        {
            int fk_pla_semestral = Convert.ToInt32(CN_Recursos.DecryptValue(idEncriptado));
            var planificaciones = CD_PlanificacionIndividual.Listar(fk_pla_semestral, out resultado, out mensaje);
            return planificaciones;
        }
    }
}
