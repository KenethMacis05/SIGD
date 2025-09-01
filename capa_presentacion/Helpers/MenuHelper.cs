using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;
using capa_entidad;
using capa_negocio;

namespace capa_presentacion.Helpers
{
    public static class MenuHelper
    {
        public static MvcHtmlString GenerarMenu(this HtmlHelper html)
        {
            CN_Menu CN_Menu = new CN_Menu();

            // Obtener el idUsuario desde ViewBag
            var viewBag = html.ViewContext.Controller.ViewBag;
            int? idUsuario = viewBag.idUsuario as int?;

            if (!idUsuario.HasValue)
            {
                return new MvcHtmlString("");
            }

            // Obtener menu del rol del usuario            
            List<MENU> menu = CN_Menu.ListarMenuPorUsuario(idUsuario.Value);

            if (menu == null || menu.Count == 0)
                return new MvcHtmlString("");

            var sb = new StringBuilder();
            var menuPadres = menu.Where(m => !m.orden.Contains(".")).OrderBy(m => decimal.Parse(m.orden)).ToList();

            foreach (var menuPadre in menuPadres)
            {
                // Verificar si este menú padre tiene hijos
                var subMenus = menu.Where(m => m.orden.StartsWith(menuPadre.orden + "."))
                                  .OrderBy(m => decimal.Parse(m.orden))
                                  .ToList();

                if (subMenus.Count > 0)
                {
                    // Menú con submenús (dropdown)
                    sb.Append($@"
                        <div class='nav-item dropdown'>
                            <a class='nav-link dropdown-toggle esp-link esp-link-hover' href='#' role='button' data-bs-toggle='dropdown' aria-expanded='false'>
                            <div class='sb-nav-link-icon'>
                                <i class='{menuPadre.icono}'></i>
                            </div>
                            {menuPadre.nombre}
                            </a>
                        <ul class='dropdown-menu'>");

                    foreach (var subMenu in subMenus)
                    {
                        sb.Append($@"
                            <li>
                                <a class='dropdown-item esp-link esp-link-hover loading-overlay' href='/{subMenu.Controller.controlador}/{subMenu.Controller.accion}'>
                                    <i class='{subMenu.icono}'></i> {subMenu.nombre}
                                </a>
                            </li>");
                    }

                    sb.Append("</ul></div>");
                }
                else
                {
                    // Menú simple sin submenús
                    sb.Append($@"
                        <a class='nav-link esp-link esp-link-hover loading-overlay' href='/{menuPadre.Controller.controlador}/{menuPadre.Controller.accion}'>
                            <div class='sb-nav-link-icon'>
                                <i class='{menuPadre.icono}'></i>
                            </div>
                            {menuPadre.nombre}
                        </a>");
                }
            }

            return new MvcHtmlString(sb.ToString());
        }
    }
}