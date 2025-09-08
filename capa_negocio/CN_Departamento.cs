using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_Departamento
    {
        private CD_Departamento CD_Departamento = new CD_Departamento();

        //Listar departamentos
        public List<DEPARTAMENTO> Listar()
        {
            return CD_Departamento.Listar();
        }

        //Crear departamento
        public int Crear(DEPARTAMENTO departamento, out string mensaje)
        {
            mensaje = string.Empty;

            if (string.IsNullOrEmpty(departamento.nombre) || string.IsNullOrEmpty(departamento.codigo))
            {
                mensaje = "Por favor, complete todos los campos.";
                return 0;
            }

            int resultado = CD_Departamento.Crear(departamento, out mensaje);

            if (resultado == 0)
            {
                mensaje = "Error al crear el departamento.";
                return 0;
            }
            else
            {
                mensaje = "Departamento creado correctamente.";
            }

            return resultado;
        }

        //Editar departamento
        public int Editar(DEPARTAMENTO departamento, out string mensaje)
        {
            mensaje = string.Empty;

            if (string.IsNullOrEmpty(departamento.nombre) || string.IsNullOrEmpty(departamento.codigo))
            {
                mensaje = "Por favor, complete todos los campos.";
                return 0;
            }

            bool actualizado = CD_Departamento.Editar(departamento, out mensaje);
            return actualizado ? 1 : 0;
        }

        //Eliminar departamento
        public int Eliminar(int idDepartamento, out string mensaje)
        {
            return CD_Departamento.Eliminar(idDepartamento, out mensaje);
        }
    }
}
