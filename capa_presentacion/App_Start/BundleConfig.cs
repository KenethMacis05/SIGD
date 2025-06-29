﻿using System.Web;
using System.Web.Optimization;

namespace capa_presentacion
{
    public class BundleConfig
    {
        // Para obtener más información sobre las uniones, visite https://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-{version}.js"));

            bundles.Add(new Bundle("~/bundles/bootstrap").Include(
                      "~/Scripts/bootstrap.bundle.js",
                      "~/Scripts/bootstrap.bundle.min.js",                      
                      "~/Scripts/bootstrap.js"));

            bundles.Add(new Bundle("~/bundles/complementos").Include(
                      "~/Scripts/fontawesome/all.min.js",
                      "~/Scripts/DataTables/jquery.dataTables.js",
                      "~/Scripts/DataTables/dataTables.responsive.js",
                      "~/Scripts/LoadingOverlay/loadingoverlay.min.js",
                      "~/Scripts/MetodosGlobales.js",

                      "~/Scripts/Select2/select2.min.js",
                      "~/Scripts/Duallistbox/dual-listbox.min.js",
                      "~/Scripts/Dropzone/dropzone.min.js",
                      
                      "~/Scripts/sweetalert2.min.js"));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                      "~/Content/bootstrap.css",
                      "~/Content/estilosLauyaut.css",
                      "~/Content/icheck-bootstrap.min.css",
                      "~/Content/icheck-bootstrap.css",
                      "~/Content/DataTables/css/jquery.dataTables.css",
                      "~/Content/DataTables/css/responsive.dataTables.css",
                      "~/Content/sweetalert2.css",
                      
                      "~/Content/Select2/select2.min.css",
                      "~/Content/Duallistbox/dual-listbox.css",
                      "~/Content/Dropzone/dropzone.min.css",

                      "~/Content/Site.css"));
        }
    }
}
