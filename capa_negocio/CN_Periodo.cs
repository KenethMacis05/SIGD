using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_Periodo
    {
        private CD_Periodos CD_Periodos = new CD_Periodos();

        //Listar periodos
        public List<PERIODO> Listar()
        {
            return CD_Periodos.Listar();
        }

        //Crear periodo
        public int Crear(PERIODO periodo, out string mensaje)
        {
            mensaje = string.Empty;

            if (string.IsNullOrEmpty(periodo.anio) || string.IsNullOrEmpty(periodo.semestre))
            {
                mensaje = "Por favor, complete todos los campos.";
                return 0;
            }

            int resultado = CD_Periodos.Crear(periodo, out mensaje);

            if (resultado == 0)
            {
                mensaje = "Error al crear el periodo.";
                return 0;
            }
            else
            {
                mensaje = "periodo creado correctamente.";
            }

            return resultado;
        }

        //Editar periodo
        public int Editar(PERIODO periodo, out string mensaje)
        {
            mensaje = string.Empty;

            if (string.IsNullOrEmpty(periodo.anio) || string.IsNullOrEmpty(periodo.semestre))
            {
                mensaje = "Por favor, complete todos los campos.";
                return 0;
            }

            bool actualizado = CD_Periodos.Editar(periodo, out mensaje);
            return actualizado ? 1 : 0;
        }

        //Eliminar periodo
        public int Eliminar(int idPeriodo, out string mensaje)
        {
            return CD_Periodos.Eliminar(idPeriodo, out mensaje);
        }
    }
}
