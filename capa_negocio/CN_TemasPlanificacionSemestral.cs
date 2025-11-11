using System;
using System.Collections;
using capa_datos;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using capa_entidad;

namespace capa_negocio
{
    public class CN_TemasPlanificacionSemestral
    {
        CD_TemasPlanificacionSemestral CD_TemasPlanificacionSemestral = new CD_TemasPlanificacionSemestral();
        CN_Recursos CN_Recursos = new CN_Recursos();

        public List<TEMAPLANIFICACIONSEMESTRAL> Listar(string idEncriptado, out int resultado, out string mensaje)
        {
            int fk_pla_semestral = Convert.ToInt32(CN_Recursos.DecryptValue(idEncriptado));

            var temas = CD_TemasPlanificacionSemestral.Listar(fk_pla_semestral, out resultado, out mensaje);
            
            return temas;
        }

        public int Crear(TEMAPLANIFICACIONSEMESTRAL tema, out string mensaje)
        {
            mensaje = string.Empty;

            if (string.IsNullOrEmpty(tema.tema))
            {
                mensaje = "Por favor, complete todos los campos.";
                return 0;
            }

            int resultado = CD_TemasPlanificacionSemestral.Crear(tema, out mensaje);

            return resultado;
        }
        
        public int Editar(TEMAPLANIFICACIONSEMESTRAL tema, out string mensaje)
        {
            mensaje = string.Empty;

            if (string.IsNullOrEmpty(tema.tema))
            {
                mensaje = "Por favor, complete todos los campos.";
                return 0;
            }

            bool actualizado = CD_TemasPlanificacionSemestral.Editar(tema, out mensaje);
            return actualizado ? 1 : 0;
        }

        public int Eliminar(int id_tema, out string mensaje)
        {
            return CD_TemasPlanificacionSemestral.Eliminar(id_tema, out mensaje);
        }
    }
}
