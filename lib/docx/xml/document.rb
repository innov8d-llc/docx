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
			
				if uri != XML::DOC_NS
					return
				end
			
				if !@in_body
					if name == 'body'
						@in_body = true
					end
				
					return
				end
			
				if @para
					@para.start_element_namespace(name, attrs, prefix, uri, ns)
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

				if uri != XML::DOC_NS
					return
				end
			
				if name == 'body'
					@in_body = false
				
					return
				end
				
				if @para
					if name == 'p'
						@parent.parsed(@para)
						@para = nil
					else
						@para.end_element_namespace(name, prefix, uri)
					end
					
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