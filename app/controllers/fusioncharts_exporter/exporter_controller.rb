require_dependency "fusioncharts_exporter/application_controller"

module FusionchartsExporter
  class ExporterController < ApplicationController

    # The action that controls the export
    def index
      @exporter = Export.new
      @exporter.setConfigFile(File.join(Rails.root, "config", "fusioncharts_exporter.yml"))
      @exporter.setParams(params)
      @exporter.process_image
      # config = YAML.load_file(File.join(Rails.root, "config", "fusioncharts_exporter.yml"))
      # @exporter = FusionchartsExporter::Base.new(config, params)
      # @options = @exporter.get_options

      return save if @exporter.downloadable?

      # return save if @exporter.saveable?

    end

    private

    # Download helper
    def download
      File.open(@exporter.get_downloaded_filename, "r") do |f|
        send_data f.read, :filename => @exporter.get_export_filename, :type => @exporter.get_mime_type

        @exporter.remove_files
      end
    end

    # Save helper
    def save
      if @exporter.save
        return render :json => { "success" => true }
      end

      return render :json => { "success" => false }
    end

  end
end
