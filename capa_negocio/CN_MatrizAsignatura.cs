using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_MatrizAsignatura
    {
        CD_MatrizAsignatura CD_MatrizAsignatura = new CD_MatrizAsignatura();

        public bool Asignar(List<MATRIZASIGNATURA> asignaturas, out string mensaje)
        {
            mensaje = string.Empty;

            // Validar que la lista no esté vacía
            if (asignaturas == null || asignaturas.Count == 0)
            {
                mensaje = "Debe proporcionar al menos una asignatura para asignar";
                return false;
            }

            // Procesar cada asignatura individualmente
            var resultados = new List<string>();
            bool exitoGeneral = true;

            foreach (var asignatura in asignaturas)
            {
                string mensajeIndividual;
                int resultado = CD_MatrizAsignatura.AsignarAsignaturaMatriz(asignatura, out mensajeIndividual);

                if (resultado > 0)
                {
                    resultados.Add($"✓ {mensajeIndividual}");
                }
                else
                {
                    resultados.Add($"✗ {mensajeIndividual}");
                    exitoGeneral = false;
                }
            }

            // Construir mensaje consolidado
            mensaje = string.Join(" | ", resultados);

            return exitoGeneral;
        }
    }
}