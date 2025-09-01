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

        public List<MENU> ListarMenusPorRol(int IdRol)
        {
            if (IdRol <= 0)
                throw new ArgumentException("El IdRol debe ser mayor que cero.");

            try
            {
                return CD_Menu.ObtenerMenusPorRol(IdRol);

            }
            catch (Exception ex)
            {
                throw new Exception($"Error al obtener menú: {ex.Message}");
            }
        }

        public List<MENU> ListarMenusNoAsignadosPorRol(int IdRol)
        {
            if (IdRol <= 0)
                throw new ArgumentException("El IdRol debe ser mayor que cero.");

            try
            {
                return CD_Menu.ObtenerMenusNoAsignadosPorRol(IdRol);

            }
            catch (Exception ex)
            {
                throw new Exception($"Error al obtener menú: {ex.Message}");
            }
        }

        public List<MENU> ListarTodosLosMenus()
        {
            return CD_Menu.ObtenerTodosLosMenus();
        }

        public Dictionary<int, (int Codigo, string Mensaje)> AsignarMenus(int IdRol, List<int> IdsMenu)
        {
            var resultados = new Dictionary<int, (int, string)>();

            foreach (var IdMenu in IdsMenu)
            {
                try
                {
                    int resultado = CD_Menu.AsignarMenusPorRol(IdRol, IdMenu);
                    string mensaje = ObtenerMensajeResultado(resultado);

                    bool esExitoso = resultado > 0 || resultado == -2;

                    resultados.Add(IdMenu, (esExitoso ? 1 : -1, mensaje));
                }
                catch (Exception ex)
                {
                    resultados.Add(IdMenu, (-1, $"Error al asignar el menú: {ex.Message}"));
                }
            }

            return resultados;
        }

        private string ObtenerMensajeResultado(int codigo)
        {
            if (codigo > 0)
                return "Menus asignado correctamente";
            switch (codigo)
            {
                case -1: return "El menú no existe o está inactivo";
                case -2: return "El rol ya tiene asignado este menú";
                default: return "Error desconocido al asignar menú";
            }
        }

        public int EliminarMenuDelRol(int IdMenuRol, out string mensaje)
        {
            bool eliminado = CD_Menu.EliminarMenuDelRol(IdMenuRol, out mensaje);
            return eliminado ? 1 : 0;
        }
    }
}
