using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_Modalidad
    {
        private CD_Modalidad CD_Modalidad = new CD_Modalidad();

        // Listar modalidades
        public List<MODALIDAD> Listar()
        {
            return CD_Modalidad.Listar();
        }

        // Crear modalidad
        public int Crear(MODALIDAD modalidad, out string mensaje)
        {
            mensaje = string.Empty;

            if (string.IsNullOrEmpty(modalidad.nombre))
            {
                mensaje = "Por favor, ingrese el nombre de la modalidad.";
                return 0;
            }

            int resultado = CD_Modalidad.Crear(modalidad, out mensaje);

            if (resultado == 0)
            {
                mensaje = "Error al crear la modalidad.";
                return 0;
            }
            else
            {
                mensaje = "Modalidad creada correctamente.";
            }

            return resultado;
        }

        // Editar modalidad
        public int Editar(MODALIDAD modalidad, out string mensaje)
        {
            mensaje = string.Empty;

            if (string.IsNullOrEmpty(modalidad.nombre))
            {
                mensaje = "Por favor, ingrese el nombre de la modalidad.";
                return 0;
            }

            bool actualizado = CD_Modalidad.Editar(modalidad, out mensaje);
            return actualizado ? 1 : 0;
        }

        // Eliminar modalidad
        public int Eliminar(int idModalidad, out string mensaje)
        {
            return CD_Modalidad.Eliminar(idModalidad, out mensaje);
        }

    }
}
