using capa_datos;
using capa_entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_DominioRol
    {
        private CD_DominioRol CD_DominioRol = new CD_DominioRol();

        public List<DOMINIOROL> ListarDominiosPorRol(int IdRol, int IdDominio)
        {
            try
            {
                return CD_DominioRol.ObtenerDominioPorRol(IdRol, IdDominio);
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar dominios por rol: " + ex.Message);
            }
        }

        public List<DOMINIO> ListarDominiosNoAsignados(int IdRol, int IdDominio)
        {
            try
            {
                return CD_DominioRol.ObtenerDominiosNoAsignados(IdRol, IdDominio);
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar dominios no asignados: " + ex.Message);
            }
        }

        public Dictionary<int, (int Codigo, string Mensaje)> AsignarDominio(int IdRol, List<int> IdsDominios)
        {
            var resultados = new Dictionary<int, (int, string)>();

            foreach (var idDominio in IdsDominios)
            {
                try
                {
                    int resultado = CD_DominioRol.AsignarDominio(IdRol, idDominio);
                    string mensaje = ObtenerMensajeResultado(resultado);

                    // Considerar como éxito tanto los nuevos permisos como los ya existentes
                    bool esExitoso = resultado > 0 || resultado == -2;

                    resultados.Add(idDominio, (esExitoso ? 1 : -1, mensaje));
                }
                catch (Exception ex)
                {
                    resultados.Add(idDominio, (-1, $"Error al asignar dominio: {ex.Message}"));
                }
            }

            return resultados;
        }

        private string ObtenerMensajeResultado(int codigo)
        {
            if (codigo > 0)
                return "Dominio asignado correctamente";
            switch (codigo)
            {
                case -1: return "Dominio no existe o está inactivo";
                case -2: return "El rol ya tiene asignado este dominio";
                default: return "Error desconocido al asignar dominio";
            }
        }

        public Dictionary<int, (int Codigo, string Mensaje)> QuitarDominioAsignado(List<int> IdsDominios, out string mensaje)
        {
            var resultados = new Dictionary<int, (int, string)>();
            mensaje = string.Empty;

            foreach (var idDominio in IdsDominios)
            {
                try
                {
                    bool resultado = CD_DominioRol.QuitarDominioAsignado(idDominio, out string mensajeIndividual);

                    // Considerar como éxito tanto los nuevos permisos como los ya existentes
                    bool esExitoso = resultado ? true : false;

                    resultados.Add(idDominio, (esExitoso ? 1 : -1, mensajeIndividual));
                    if (!string.IsNullOrEmpty(mensajeIndividual))
                    {
                        mensaje += mensajeIndividual + Environment.NewLine;
                    }
                }
                catch (Exception ex)
                {
                    resultados.Add(idDominio, (-1, $"Error al asignar dominio: {ex.Message}"));
                    mensaje += $"Error al asignar dominio: {ex.Message}" + Environment.NewLine;
                }
            }

            return resultados;
        }

        public (bool Success, string Message) ReemplazarDominiosRol(int IdRol, List<int> IdsDominios, int? IdTipoDominio = null, string TipoDominio = null)
        {
            try
            {
                int resultado = CD_DominioRol.ReemplazarDominiosRol(IdRol, IdsDominios, IdTipoDominio, TipoDominio);

                if (resultado == 1)
                {
                    return (true, "Dominios actualizados correctamente");
                }
                else
                {
                    return (false, "Error al actualizar los dominios");
                }
            }
            catch (Exception ex)
            {
                return (false, $"Error al reemplazar dominios: {ex.Message}");
            }
        }
    }
}
