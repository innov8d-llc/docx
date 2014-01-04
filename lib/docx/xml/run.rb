module DOCX
	
	module XML
	
		class Run
			def initialize
				@in_rpr = false
				@in_t = false
				@string = nil
				@run_properties = RunProperties.new
				@children = []
			end
			
			# accessors
			
			def text
				@children.join('')
			end
			
			def italics
				@run_properties.italics
			end
			
			def bold
				@run_properties.bold
			end
			
			# actions
			
			def start_element_namespace(name, attrs = [], prefix = nil, uri = nil, ns = [])
				if uri != XML::DOC_NS
					return
				end
				
				if @in_rpr
					@run_properties.start_element_namespace(name, attrs, prefix, uri, ns)
					return
				end
				
				if @in_t
					return
				end
			
				case name
				when 'rPr'
					@in_rpr = true
				when 't'
					@string = ''
					@in_t = true
				when 'br'
					@children << "\n"
					puts "run>>> br"
				when 'drawing'
				else
					puts "run>>> #{name} #{attrs.inspect} #{prefix} #{uri} #{ns.inspect}"
				end
			end
		
			def end_element_namespace(name, prefix = nil, uri = nil)
				if uri != XML::DOC_NS
					return
				end
				
				if @in_rpr
					if name == 'rPr'
						@in_rpr = false
						return
					end
					
					@run_properties.end_element_namespace(name, prefix, uri)
					return
				end
				
				if @in_t
					if name == 't'
						@in_t = false
						@children << @string
						puts "run>>> text: '#{@string}'"
						@string = nil
					end
					
					return
				end
				
				case name
				when 'br'
				when 'drawing'
				else
					puts "run>>> /#{name} #{prefix} #{uri}"
				end
			end
			
			def characters(string)
				if @in_t
					@string << string
				end
			end
			
		end
		
	end
	
end