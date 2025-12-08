using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_Asignatura
    {
        private CD_Asignatura CD_Asignatura = new CD_Asignatura();

        //Listar asignaturas
        public List<ASIGNATURA> Listar(bool soloIntegradoras = false)
        {
            return CD_Asignatura.Listar(soloIntegradoras);
        }

        //Crear asignatura
        public int Crear(ASIGNATURA asignatura, out string mensaje)
        {
            mensaje = string.Empty;

            if (string.IsNullOrEmpty(asignatura.nombre) || string.IsNullOrEmpty(asignatura.codigo))
            {
                mensaje = "Por favor, complete todos los campos.";
                return 0;
            }

            int resultado = CD_Asignatura.Crear(asignatura, out mensaje);

            if (resultado == 0)
            {
                mensaje = "Error al crear la asignatura.";
                return 0;
            }
            else
            {
                mensaje = "Asignatura creada correctamente.";
            }

            return resultado;
        }

        //Editar asignatura
        public int Editar(ASIGNATURA asignatura, out string mensaje)
        {
            mensaje = string.Empty;

            if (string.IsNullOrEmpty(asignatura.nombre) || string.IsNullOrEmpty(asignatura.codigo))
            {
                mensaje = "Por favor, complete todos los campos.";
                return 0;
            }

            bool actualizado = CD_Asignatura.Editar(asignatura, out mensaje);
            return actualizado ? 1 : 0;
        }

        //Eliminar asignatura
        public int Eliminar(int idAsignatura, out string mensaje)
        {
            return CD_Asignatura.Eliminar(idAsignatura, out mensaje);
        }
    }
}
