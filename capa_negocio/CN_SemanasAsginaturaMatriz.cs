using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_SemanasAsginaturaMatriz
    {
        CD_SemanasAsginaturaMatriz CD_SemanasAsginaturaMatriz = new CD_SemanasAsginaturaMatriz();

        public int Actualizar(SEMANASASIGNATURAMATRIZ semana, out string mensaje)
        {
            mensaje = string.Empty;

            // Validaciones básicas
            if (semana == null)
            {
                mensaje = "Los datos de la asignatura no pueden ser nulos";
                return 0;
            }

            if (semana.id_semana <= 0)
            {
                mensaje = "Debe especificar una semana válida";
                return 0;
            }

            // Llamar al método de la capa de datos
            return CD_SemanasAsginaturaMatriz.Actualizar(semana, out mensaje);
        }

        public int Crear(SEMANASASIGNATURAMATRIZ semana, out string mensaje)
        {
            throw new NotImplementedException();
        }

        // listar semanas de asignatura matriz
        public List<SEMANASASIGNATURAMATRIZ> Listar(int fk_matriz_asignatura, out int resultado, out string mensaje)
        {
            return CD_SemanasAsginaturaMatriz.Listar(fk_matriz_asignatura, out resultado, out mensaje);
        }

    }
}
