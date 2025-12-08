using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_Turno
    {
        private CD_Turno CD_Turno = new CD_Turno();

        // Listar turnos
        public List<TURNO> Listar()
        {
            return CD_Turno.Listar();
        }

        // Crear turno
        public int Crear(TURNO turno, out string mensaje)
        {
            mensaje = string.Empty;

            if (string.IsNullOrEmpty(turno.nombre))
            {
                mensaje = "Por favor, ingrese el nombre del turno.";
                return 0;
            }

            if (turno.fk_modalidad <= 0)
            {
                mensaje = "Seleccione una modalidad válida.";
                return 0;
            }

            int resultado = CD_Turno.Crear(turno, out mensaje);

            if (resultado == 0)
            {
                mensaje = mensaje != string.Empty ? mensaje : "Error al crear el turno.";
                return 0;
            }
            else
            {
                mensaje = "Turno creado correctamente.";
            }

            return resultado;
        }

        // Editar turno
        public int Editar(TURNO turno, out string mensaje)
        {
            mensaje = string.Empty;

            if (string.IsNullOrEmpty(turno.nombre))
            {
                mensaje = "Por favor, ingrese el nombre del turno.";
                return 0;
            }

            if (turno.fk_modalidad <= 0)
            {
                mensaje = "Seleccione una modalidad válida.";
                return 0;
            }

            bool actualizado = CD_Turno.Editar(turno, out mensaje);
            return actualizado ? 1 : 0;
        }

        // Eliminar turno
        public int Eliminar(int idTurno, out string mensaje)
        {
            return CD_Turno.Eliminar(idTurno, out mensaje);
        }
    }
}
