module DOCX
	
	module XML
	
		class Hyperlink < Generic
			
			def initialize(attrs)
				@rel_id = get_attr('id', 'http://schemas.openxmlformats.org/officeDocument/2006/relationships', attrs)
				@run = nil
				@children = []
			end
			
			# accessors
			
			def rel_id
				@rel_id
			end
			
			def runs
				@children
			end
			
			# actions
			
			def start_element_namespace(name, attrs = [], prefix = nil, uri = nil, ns = [])

				if @run
					@run.start_element_namespace(name, attrs, prefix, uri, ns)
					return
				end

				if uri != XML::DOC_NS
					return
				end
				
				case name
				when 'r'
					puts 'NEW HYPERLINK RUN'
					@run = Run.new
					@children << @run
				else
					puts "hyperlink>>> #{name} #{attrs.inspect} #{prefix} #{uri} #{ns.inspect}"
				end
			end
		
			def end_element_namespace(name, prefix = nil, uri = nil)
				
				if @run
					if (name == 'r') && (uri == XML::DOC_NS)
						@run = nil
						return
					end

					@run.end_element_namespace(name, prefix, uri)
					return
				end

				if uri != XML::DOC_NS
					return
				end
				
				case name
				when 'br'
				else
					puts "hyperlink>>> /#{name} #{prefix} #{uri}"
				end
			end
			
			def characters(string)
				if @run
					@run.characters(string)
				end
			end
			
		end
		
	end
	
end