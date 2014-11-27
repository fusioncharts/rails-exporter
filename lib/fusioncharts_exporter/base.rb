module FusionchartsExporter
  class Base

    # Path where all temporary images will be stored.
    FUSIONCHARTS_TEMP_PATH = "tmp/fusioncharts"

    # config - The yaml configuration
    # params - The request parameters
    # export_params - Parameters that are specific to the current export
    # options - Temporary options with all the meta information
    def initialize(config, params)
      @config = config
      @params = params
      @export_params = @params[:parameters]
      @options = {}
      @export_params.split("|").each do |p|
        splitted = p.split("=")
        @options[splitted[0]] = splitted[1]
      end
      @random_filename = generate_random_filename
      @random_filename_path = File.join(Rails.root, FUSIONCHARTS_TEMP_PATH, @random_filename)

      tempfilename = generate_temp_filename();
      @options['tempfilename'] = tempfilename
      @options['filepath'] = tempfilename + ".svg"
      @options['meta'] = get_meta_options
      @remove_files = [ @options['filepath'] ]

      process_image

      return self
    end

    # Return the appropriate mime type
    def get_mime_type(options=nil)
      options = options || @options
      mime_types = {
        'jpg' => 'image/jpeg',
        'jpeg' => 'image/jpeg',
        'gif' => 'image/gif',
        'png' => 'image/png',
        'pdf' => 'application/pdf',
        'svg' => 'image/svg+xml'
      }

      if(mime_types[options['exportformat']])
        return mime_types[options['exportformat']]
      else
        raise "Invalid mime type"
      end
    end 

    # Return the options instance variable
    def get_options
      @options
    end

    # Return the filename with the absolute path of the current downloaded item
    def get_downloaded_filename
      get_download_filename
    end

    # Save the image on the server
    def save
      dest = get_destination
      stat = FileUtils.mv(get_download_filename, dest)

      @remove_files.reject!{ |f| f === get_download_filename }

      self.remove_files

      if stat
        return true
      end

      return false
    end

    # Check whether current export action is download
    def downloadable?
      @options['exportaction'] === 'download' ? true : false
    end

    # Check whether current export action is save
    def saveable?
      @options['exportaction'] === 'save' ? true : false
    end

    # Remove all the temporary files
    def remove_files
      @remove_files.each { |f| File.delete(f) }
    end

    # Get the name file that will be called during download
    def get_export_filename
       @options['exportfilename'] + "." + @options['exportformat']
    end

    private

    # Generate a random filename
    def generate_random_filename
      SecureRandom.urlsafe_base64 + "_" + Time.now.to_i.to_s
    end

    # Process the image, that exports the current stream into various image formats
    def process_image

      File.open(@options['filepath'], "w") do |f|
        f.write(@params[:stream])
      end

      extension = @options['exportformat']

      unless(extension == 'svg')

        # Create a PNG / PDF image
        temp_extension = extension == 'pdf' ? 'pdf' : 'png'
        cmd = @config['inkscape_path'] + " --without-gui --export-background=#{@options['meta']['bgColor']} --file=#{@options['filepath']} --export-#{temp_extension}=#{@options['tempfilename']}.#{temp_extension} --export-width=#{@options['meta']['width']} --export-height=#{@options['meta']['height']}"
        raise "Inkscape was unable to convert svg to png. Is Inkscape configured and installed correctly?" unless system(cmd)
        # @remove_files << @options['tempfilename'] + ".#{temp_extension}"

        # Create JPG image
        if  extension == 'jpg' || extension == 'jpeg'
          cmd = @config['imagemagick_path'] + " -quality 100 #{@options['tempfilename']}.png #{@options['tempfilename']}.#{extension}"
          raise "ImageMagick was unable to convert to jpg. Is ImageMagick configured and installed correctly?" unless system(cmd)
          @remove_files << @options['tempfilename'] + ".jpg"
        end
      end

    end

    # Get the temporary filename
    def generate_temp_filename
      @random_filename_path
    end

    # Get the full download filename with the path
    def get_download_filename
      @options['tempfilename'] + "." + @options['exportformat']
    end

    # Get all meta request paramaters
    def get_meta_options

      meta = {}
      @params.each do |p|
        match = p[0].match(/^meta_(.*)/)
        if(match)
          meta[$1] = p[1]
        end
      end

      return meta

    end

    # Get the absoulte save path where the file be saved on the server
    def get_destination
      File.join(Rails.root, @config['save_path'], @random_filename + "." + @options['exportformat'])
    end


  end
end
