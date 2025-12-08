// ReportesRDLC/Interfaces/IReporteGenerador.cs
using Microsoft.Reporting.WebForms;
using System.Collections.Generic;
using System.Data;

namespace capa_presentacion.ReportesRDLC
{
    public interface IReporteGenerador
    {
        string NombreReporte { get; }
        Dictionary<string, object> ObtenerParametros();
        List<ReportDataSource> ObtenerDataSources();
    }
}