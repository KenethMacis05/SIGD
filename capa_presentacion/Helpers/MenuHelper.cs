﻿using System;
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

            foreach (var iten in menu)
            {
                sb.Append($@"                            
                     <a class='nav-link esp-link esp-link-hover loading-overlay' href='/{iten.Controller.controlador}/{iten.Controller.accion}'>
                         <div class='sb-nav-link-icon'>
                             <i class='{iten.icono}'></i>
                         </div>
                             {iten.nombre}
                     </a>"
                 );
            }
            return new MvcHtmlString(sb.ToString());
        }
    }
}