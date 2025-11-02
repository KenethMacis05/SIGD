using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_AccionIntegradoraTipoEvaluaciona
    {
        CD_AccionIntegradoraTipoEvaluaciona CD_AccionIntegradoraTipoEvaluaciona = new CD_AccionIntegradoraTipoEvaluaciona();
        private CN_Recursos CN_Recursos = new CN_Recursos();

        public List<ACCIONINTEGRADORA_TIPOEVALUACION> ListarPorMatriz(string id_encriptado, out int resultado, out string mensaje)
        {

            int id = Convert.ToInt32(CN_Recursos.DecryptValue(id_encriptado));

            var accionTipoMatriz = CD_AccionIntegradoraTipoEvaluaciona.ListarPorMatriz(id, out resultado, out mensaje);

            // Solo agregar la propiedad encriptada a cada objeto existente
            foreach (var accionTipo in accionTipoMatriz)
            {
                accionTipo.id_accion_tipo_encriptado = CN_Recursos.EncryptValue(accionTipo.id_accion_tipo.ToString());
                accionTipo.fk_matriz_integracion_encriptado = CN_Recursos.EncryptValue(accionTipo.fk_matriz_integracion.ToString());
            }

            return accionTipoMatriz;
        }
    }
}
