using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_Carrera
    {
        private CD_Carrera CD_Carrera = new CD_Carrera();

        //Listar carreras
        public List<CARRERA> Listar()
        {
            return CD_Carrera.Listar();
        }

        //Crear departamento
        public int Crear(CARRERA carrera, out string mensaje)
        {
            mensaje = string.Empty;

            if (string.IsNullOrEmpty(carrera.nombre) || string.IsNullOrEmpty(carrera.codigo))
            {
                mensaje = "Por favor, complete todos los campos.";
                return 0;
            }

            int resultado = CD_Carrera.Crear(carrera, out mensaje);

            if (resultado == 0)
            {
                mensaje = "Error al crear la carrera.";
                return 0;
            }
            else
            {
                mensaje = "Carrera creada correctamente.";
            }

            return resultado;
        }

        //Editar carrera
        public int Editar(CARRERA carrera, out string mensaje)
        {
            mensaje = string.Empty;

            if (string.IsNullOrEmpty(carrera.nombre) || string.IsNullOrEmpty(carrera.codigo))
            {
                mensaje = "Por favor, complete todos los campos.";
                return 0;
            }

            bool actualizado = CD_Carrera.Editar(carrera, out mensaje);
            return actualizado ? 1 : 0;
        }

        //Eliminar carrera
        public int Eliminar(int idCarrera, out string mensaje)
        {
            return CD_Carrera.Eliminar(idCarrera, out mensaje);
        }
    }
}
