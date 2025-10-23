using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_SemanasAsginaturaMatriz
    {
        CD_SemanasAsginaturaMatriz CD_SemanasAsginaturaMatriz = new CD_SemanasAsginaturaMatriz();
        
        // listar semanas de asignatura matriz
        public List<SEMANASASIGNATURAMATRIZ> Listar(int fk_matriz_asignatura, out int resultado, out string mensaje)
        {
            return CD_SemanasAsginaturaMatriz.Listar(fk_matriz_asignatura, out resultado, out mensaje);
        }

    }
}
