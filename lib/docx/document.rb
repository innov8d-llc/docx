module DOCX
	
	class Document
		
		def initialize(file, outfile)
			@outfile = outfile
			
			doc = XML::Document.new(self)
			parser = Nokogiri::XML::SAX::Parser.new(doc, "UTF-8")
			parser.parse(file)
		end
		
		def parsed(paragraph)
			output = nil
			
			if paragraph.is_heading?
				output = MD::Heading.new(paragraph)
			elsif paragraph.is_list?
				output = MD::ListItem.new(paragraph)
			else
				output = MD::Paragraph.new(paragraph)
			end
			
			@outfile.print output.to_s
		end
	end
	
end