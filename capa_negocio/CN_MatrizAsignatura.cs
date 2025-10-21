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

        public List<MATRIZASIGNATURA> ListarAsignaturasPorMatriz(int fk_matriz_integracion, out int resultado, out string mensaje)
        {
            return CD_MatrizAsignatura.ListarAsignaturasPorMatriz(fk_matriz_integracion, out resultado, out mensaje);
        }

        public int Asignar(MATRIZASIGNATURA matriz, out string mensaje)
        {
            mensaje = string.Empty;

            // Validaciones básicas
            if (matriz == null)
            {
                mensaje = "Los datos de la asignatura no pueden ser nulos";
                return 0;
            }

            if (matriz.fk_matriz_integracion <= 0)
            {
                mensaje = "Debe especificar una matriz de integración válida";
                return 0;
            }

            if (matriz.fk_asignatura <= 0)
            {
                mensaje = "Debe seleccionar una asignatura válida";
                return 0;
            }

            if (matriz.fk_profesor_asignado <= 0)
            {
                mensaje = "Debe seleccionar un profesor válido";
                return 0;
            }

            // Llamar al método de la capa de datos
            return CD_MatrizAsignatura.AsignarAsignaturaMatriz(matriz, out mensaje);
        }

        public int Actualizar(MATRIZASIGNATURA matriz, out string mensaje)
        {
            mensaje = string.Empty;

            // Validaciones básicas
            if (matriz == null)
            {
                mensaje = "Los datos de la asignatura no pueden ser nulos";
                return 0;
            }

            if (matriz.id_matriz_asignatura <= 0)
            {
                mensaje = "Debe especificar una asignatura de matriz válida";
                return 0;
            }

            // Verificar que al menos un campo sea proporcionado para actualizar
            if (matriz.fk_asignatura <= 0 && matriz.fk_profesor_asignado <= 0)
            {
                mensaje = "Debe proporcionar al menos una asignatura o profesor para actualizar";
                return 0;
            }

            // Llamar al método de la capa de datos
            return CD_MatrizAsignatura.ActualizarMatrizAsignatura(matriz, out mensaje);
        }

        public int Eliminar(int id_matriz_asignatura, int fk_profesor_propietario, out string mensaje)
        {
            bool eliminado = CD_MatrizAsignatura.Eliminar(id_matriz_asignatura, fk_profesor_propietario, out mensaje);
            return eliminado ? 1 : 0;
        }
    }
}