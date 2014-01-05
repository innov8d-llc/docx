module DOCX
	
	class Document
		
		def initialize(file, outfile, relations)
			@outfile = outfile

			@in_list = false
			@in_code = false
			@relations = relations
			
			doc = XML::Document.new(self)
			parser = Nokogiri::XML::SAX::Parser.new(doc, "UTF-8")
			parser.parse(file)
		end
		
		def parsed(paragraph)
			output = nil
			
			if @in_list && !paragraph.is_list?
				@outfile.print "\n"
			end
			
			if @in_code && !paragraph.is_code?
				@outfile.print "\n"
			end
			
			@in_list = false
			@in_code = false
			
			if paragraph.is_heading?
				output = MD::Heading.new(paragraph)
			elsif paragraph.is_list?
				output = MD::ListItem.new(paragraph)
				@in_list = true
			elsif paragraph.is_code?
				output = MD::Code.new(paragraph)
				@in_code = true
			else
				output = MD::Paragraph.new(paragraph, @relations)
			end
			
			@outfile.print output.to_s
		end
	end
	
end