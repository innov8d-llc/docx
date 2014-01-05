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

			if paragraph.is_a?(XML::Table)
				@outfile.print MD::Table.new(paragraph, @relations).to_s
				return
			end
			
			if @in_list && !paragraph.is_list?
				@outfile.print "\n"
			end
			
			if @in_code && !paragraph.is_code?
				@outfile.print "\n"
			end
			
			if @in_quote && !paragraph.is_quote?
				@outfile.print "\n"
			end
			
			@in_list = false
			@in_code = false
			@in_quote = false
			
			if paragraph.is_heading?
				output = MD::Heading.new(paragraph)
			elsif paragraph.is_list?
				output = MD::ListItem.new(paragraph)
				@in_list = true
			elsif paragraph.is_code?
				output = MD::Code.new(paragraph)
				@in_code = true
			elsif paragraph.is_quote?
				output = MD::Quote.new(paragraph)
				@in_quote = true
			else
				output = MD::Paragraph.new(paragraph, @relations)
			end
			
			@outfile.print output.to_s
		end
	end
	
end