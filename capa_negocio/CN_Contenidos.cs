using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_Contenidos
    {
        CD_Contenidos CD_Contenidos = new CD_Contenidos();

        public int Actualizar(CONTENIDOS contenido, out string mensaje)
        {
            mensaje = string.Empty;

            // Validaciones básicas
            if (contenido == null)
            {
                mensaje = "Los datos de la asignatura no pueden ser nulos";
                return 0;
            }

            if (contenido.id_contenido <= 0)
            {
                mensaje = "Debe especificar un contenido válido";
                return 0;
            }

            // Llamar al método de la capa de datos
            return CD_Contenidos.Actualizar(contenido, out mensaje);
        }

        public int Crear(CONTENIDOS semana, out string mensaje)
        {
            throw new NotImplementedException();
        }

        // listar semanas de asignatura matriz
        public List<CONTENIDOS> Listar(string fk_matriz_asignatura_encriptada, out int resultado, out string mensaje)
        {
            var fk_matriz_asignatura = Convert.ToInt32(new CN_Recursos().DecryptValue(fk_matriz_asignatura_encriptada));
            return CD_Contenidos.Listar(fk_matriz_asignatura, out resultado, out mensaje);
        }

        public List<CONTENIDOS> ObtenerContenidosPorSemana(string fk_matriz_integracion_encriptada, int numero_semana, out int resultado, out string mensaje)
        {
            var fk_matriz_integracion = Convert.ToInt32(new CN_Recursos().DecryptValue(fk_matriz_integracion_encriptada));
            return CD_Contenidos.ObtenerContenidosPorSemana(fk_matriz_integracion, numero_semana, out resultado, out mensaje);
        }
    }
}
