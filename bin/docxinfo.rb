require 'docx'

docx = DOCX.parse(ARGV[0])

puts "Images"
docx.images.each { |rel| puts rel }

puts "Hyperlinks"
docx.links.each { |rel| puts rel }