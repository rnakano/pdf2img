require 'origami'

include Origami

pdf_filename = ARGV.shift
output_dirname = ARGV.shift

pdf = PDF.read(pdf_filename, :verbosity => Parser::VERBOSE_QUIET)
pdf.revisions.first.body.values.select{|i| 
  i.instance_of?(Graphics::ImageXObject)
}.each_with_index{|image, i|
  format, data = image.to_image_file
  basename = sprintf("%03d.%s", i+1, format)
  filename = output_dirname + "/" + basename
  File.open(filename, "wb"){|file|
    file.write(data)
  }
}
