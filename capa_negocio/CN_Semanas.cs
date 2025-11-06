using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_Semanas
    {
        CD_Semanas CD_Semanas = new CD_Semanas();
        CN_Recursos CN_Recursos = new CN_Recursos();

        // Listar semanas de una matriz de integracion
        public List<SEMANAS> Listar(string fk_matriz_integracion_encriptado, out int resultado, out string mensaje)
        {
            int fk_matriz_integracion = Convert.ToInt32(CN_Recursos.DecryptValue(fk_matriz_integracion_encriptado));

            var semanas = CD_Semanas.Listar(fk_matriz_integracion, out resultado, out mensaje);
            semanas.ForEach(s =>
            {
                s.fk_matriz_integracion_encriptado = fk_matriz_integracion_encriptado;
            });

            return semanas;
        }

        // Actualizar semana
        public int Actualizar(SEMANAS semana, out string mensaje)
        {
            //validaciones basicas
            if (semana.numero_semana <= 0)
            {
                mensaje = "El número de semana debe ser mayor a cero.";
                return 0;
            }

            else {
                if (semana.fecha_fin < semana.fecha_inicio)
                {
                    mensaje = "La fecha de fin no puede ser anterior a la fecha de inicio.";
                    return 0;
                }
            }

            return CD_Semanas.Actualizar(semana, out mensaje);
        }

        public int Crear(SEMANAS semana, out string mensaje)
        {
            throw new NotImplementedException();
        }
    }
}
