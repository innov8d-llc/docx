require 'nokogiri'

module DOCX
	
	
	module XML

		DOC_NS = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
	
		class Document < Nokogiri::XML::SAX::Document
			
			def initialize(parent)
				@parent = parent
			end
				
			def start_document
				@in_body = false
				@para = nil
			end
		
			def start_element_namespace(name, attrs = [], prefix = nil, uri = nil, ns = [])
			
				if !@in_body
					if (name == 'body') && (uri == XML::DOC_NS)
						@in_body = true
					end
				
					return
				end
			
				if @para
					@para.start_element_namespace(name, attrs, prefix, uri, ns)
					return
				end
			
				if uri != XML::DOC_NS
					return
				end
				
				case name
				when 'p'
					puts 'NEW PARA'
					@para = Paragraph.new(attrs)
				else
					puts ">>> #{name} #{attrs.inspect} #{prefix} #{uri} #{ns.inspect}"
				end
			
			end
		
			def end_element_namespace(name, prefix = nil, uri = nil)
			
				if !@in_body
					return
				end
			
				if (name == 'body') && (uri == XML::DOC_NS)
					@in_body = false
				
					return
				end
				
				if @para
					if (name == 'p') && (uri == XML::DOC_NS)
						@parent.parsed(@para)
						@para = nil
					else
						@para.end_element_namespace(name, prefix, uri)
					end
					
					return
				end

				if uri != XML::DOC_NS
					return
				end
			
				puts ">>> /#{name} #{prefix} #{uri}"
			
			end
			
			def characters(string)
				if @para
					@para.characters(string)
				end
			end
		
		end
		
	end
	
end