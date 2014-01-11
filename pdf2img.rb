require 'origami'

include Origami

unless ARGV.size == 2
  puts "usage: bundle exec ruby pdf2img.rb <input.pdf> <output directory name>"
  exit 1
end

pdf_filename = ARGV.shift
output_dirname = ARGV.shift
Dir.mkdir(output_dirname) unless File.exists?(output_dirname)

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
