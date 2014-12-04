# Fusioncharts Exporter Handler

FusionCharts export handler for Ruby on Rails.

## Installation

Add this line to your application's Gemfile:
~~~
gem 'fusioncharts_exporter'
~~~

And then execute:
~~~
$ bundle
~~~

## Introduction

### What is it?
FusionCharts Suite XT uses JavaScript to generate charts in the browser, using SVG and VML (for older IE). If you need to export the charts as images or PDF, you need a server-side helper library to convert the SVG to image/PDF. These export handlers allow you to take the SVG from FusionCharts charts and convert to image/PDF.

### How does the export handler work?
- A chart is generated in the browser. When the export to image or PDF button is clicked, the chart generates the SVG string to represent the current state and sends to the export handler. The export handler URL is configured via chart attributes.
- The export handler accepts the SVG string along with chart configuration like chart type, width, height etc., and uses [InkScape](https://inkscape.org/en/) and [ImageMagick](http://www.imagemagick.org/) library to convert to image or PDF.
- The export handler either writes the image or PDF to disk, based on the configuration provided by chart, or streams it back to the browser.

## Pre-requisites
You will have to install the following applications without which the exporter will fail to run.
- [Inkscape](http://inkscape.org/en/download/)
- [ImageMagick](http://www.imagemagick.org/script/download.php
)

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

## Contributing and Testing

1. Clone the repository: `TODO`
2. Run `bundle install`
3. Run `rspec` for running all the testcases.
