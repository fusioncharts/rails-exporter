# Fusioncharts Exporter Handler

Export handler for Ruby on Rails.

## Installation

Add this line to your application's Gemfile:
~~~
gem 'fusioncharts_exporter'
~~~

And then execute:
~~~
$ bundle
~~~

## Pre-requisites
You will have to install the following applications without which the exporter will fail to run.
- [Inkscape](https://inkscape.org/)
- [ImageMagick](http://www.imagemagick.org/)

## Usage
The gem provides a generator to create a some configuration files and directories. Run the following:
~~~
$ rails generate fusioncharts_exporter:install
~~~

This creates the following files and directories:
- `config/fusioncharts_exporter.yml`
- `tmp/fusioncharts/`

## Configuration
The following are the configurables to be modified as required in the `config/fusioncharts_exporter.yml`:

`inkscape_path`

Location of the Inkscape executable.

`imagemagick_path`

 Location of the ImageMagick executable.

`save_path`

Location on the server where the image will be saved.

## Mount the application
You will have to specify the end point of the export server. In order to do this, you will have to mount the export handler to your rails application. Add the following lines in `config/routes.rb`.

~~~
mount FusionchartsExporter::Engine, at: "<path>"
~~~

For eg., if you want your export server hosted at `http://<my-website>/export`, then add the following lines:
~~~
mount FusionchartsExporter::Engine, at: "export"
~~~
