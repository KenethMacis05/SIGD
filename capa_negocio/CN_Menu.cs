using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using capa_datos;
using capa_entidad;

namespace capa_negocio
{
    public class CN_Menu
    {
        private CD_Menu CD_Menu = new CD_Menu();

        public int Editar(MENU menu, out string mensaje)
        {
            throw new NotImplementedException();
        }

        public int Eliminar(int id_menu, out string mensaje)
        {
            throw new NotImplementedException();
        }

        public List<MENU> ListarMenuPorUsuario(int IdUsuario)
        {
            try
            {
                return CD_Menu.ObtenerMenuPorUsuario(IdUsuario);

            }
            catch (Exception ex)
            {
                throw new Exception($"Error al obtener menú: {ex.Message}");
            }
        }

        public List<MENU> ObtenerMenusPorRol(int idRol)
        {
            try
            {
                if (idRol <= 0)
                {
                    throw new ArgumentException("El ID del rol debe ser un valor positivo.");
                }

                return CD_Menu.ObtenerMenuPorRoles(idRol);
            }
            catch (Exception ex)
            {
                throw new Exception("Error en la capa de negocio al obtener menús por rol: " + ex.Message);
            }
        }

        public int Registra(MENU menu, out string mensaje)
        {
            throw new NotImplementedException();
        }
    }
}
