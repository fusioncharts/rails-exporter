Rails.application.routes.draw do

  mount FusionchartsExporter::Engine => "/fusioncharts_exporter"
end
