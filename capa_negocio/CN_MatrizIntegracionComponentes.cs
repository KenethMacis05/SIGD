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
    public class CN_MatrizIntegracionComponentes
    {
        CD_MatrizIntegracionComponentes CD_MatrizIntegracion = new CD_MatrizIntegracionComponentes();

        // Listar matrices de integración de componentes por usuario
        public List<MATRIZINTEGRACIONCOMPONENTES> Listar(int id_usuario, out int resultado, out string mensaje)
        {
            return CD_MatrizIntegracion.Listar(id_usuario, out resultado, out mensaje);
        }

        // Crear matriz de integración de componentes
        public int Crear(MATRIZINTEGRACIONCOMPONENTES matriz, out string mensaje)
        {
            mensaje = string.Empty;

            // Validación de campos obligatorios
            if (string.IsNullOrEmpty(matriz.nombre))
            {
                mensaje = "Por favor, complete todos los campos obligatorios.";
                return 0;
            }

            if (matriz.fk_profesor == 0)
            {
                mensaje = "Por favor, seleccione un profesor.";
                return 0;
            }

            if (matriz.fk_periodo == 0)
            {
                mensaje = "Por favor, seleccione un periodo.";
                return 0;
            }

            return CD_MatrizIntegracion.RegistrarMatrizIntegracion(matriz, out mensaje);
        }

        // Editar matriz de integración de componentes
        public int Editar(MATRIZINTEGRACIONCOMPONENTES matriz, out string mensaje)
        {
            mensaje = string.Empty;

            // Validación de campos obligatorios
            if (string.IsNullOrEmpty(matriz.nombre))
            {
                mensaje = "Por favor, complete todos los campos obligatorios.";
                return 0;
            }

            bool actualizar = CD_MatrizIntegracion.ActualizarMatrizIntegracion(matriz, out mensaje);
            return actualizar ? 1 : 0;
        }

        // Eliminar matriz de integración de componentes
        public int Eliminar(int id_matriz, int id_usuario, out string mensaje)
        {
            bool eliminar = CD_MatrizIntegracion.EliminarMatrizIntegracion(id_matriz, id_usuario, out mensaje);
            return eliminar ? 1 : 0;
        }

        public MATRIZINTEGRACIONCOMPONENTES ObtenerMatrizPorId(int id, int id_usuario)
        {
            return CD_MatrizIntegracion.ObtenerMatrizPorId(id, id_usuario);
        }
    }
}
