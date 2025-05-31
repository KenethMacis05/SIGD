using Jose;
using Microsoft.Ajax.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace capa_presentacion.webtoken
{
    public class GenerarOnlyOfficeToken
    {
        // Recibe el payload (configuración) y devuelve el JWT en string
        public string GenerarTokenOnlyOffice(object payload)
        {
            var secret = "SERVERSIGDONLYOFFICE12358"; // Debe coincidir con tu contenedor Docker
            return JWT.Encode(payload, Encoding.UTF8.GetBytes(secret), JwsAlgorithm.HS256);
        }
    }
}