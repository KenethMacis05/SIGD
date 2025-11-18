using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_AreaConocimiento
    {
        private CD_AreaConocimiento CD_AreaConocimiento = new CD_AreaConocimiento();

        //Listar área de conocimiento
        public List<AREACONOCIMIENTO> Listar()
        {
            return CD_AreaConocimiento.Listar();
        }

        //Listar áreas de conocimiento por dominios
        public List<AREACONOCIMIENTO> ListarPorDominios(int UsuarioId)
        {
            return CD_AreaConocimiento.ListarPorDominios(UsuarioId);
        }

        //Crear área de conocimiento
        public int Crear(AREACONOCIMIENTO area, out string mensaje)
        {
            mensaje = string.Empty;

            if (string.IsNullOrEmpty(area.nombre) || string.IsNullOrEmpty(area.codigo))
            {
                mensaje = "Por favor, complete todos los campos.";
                return 0;
            }

            int resultado = CD_AreaConocimiento.Crear(area, out mensaje);

            if (resultado == 0)
            {
                mensaje = "Error al crear el área de conocimiento.";
                return 0;
            }
            else
            {
                mensaje = "Área de conocimiento creada correctamente.";
            }

            return resultado;
        }

        //Editar área de conocimiento
        public int Editar(AREACONOCIMIENTO area, out string mensaje)
        {
            mensaje = string.Empty;

            if (string.IsNullOrEmpty(area.nombre) || string.IsNullOrEmpty(area.codigo))
            {
                mensaje = "Por favor, complete todos los campos.";
                return 0;
            }

            bool actualizado = CD_AreaConocimiento.Editar(area, out mensaje);
            return actualizado ? 1 : 0;
        }

        //Eliminar área de conocimiento
        public int Eliminar(int idArea, out string mensaje)
        {
            return CD_AreaConocimiento.Eliminar(idArea, out mensaje);
        }
    }
}
