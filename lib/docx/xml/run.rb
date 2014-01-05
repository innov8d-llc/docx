module DOCX
	
	module XML
	
		class Run
			def initialize
				@in_rpr = false
				@in_t = false
				@string = nil
				@drawing = nil
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
			
			def is_image?
				@children.any? { |child| child.is_a?(Drawing) }
			end
			
			def image_id
				if !is_image?
					return nil
				end
				
				drawing = @children.select { |child| child.is_a?(Drawing) }.first
				
				if !drawing
					raise 'Image has no drawing.'
				end
				
				drawing.ref_id
			end
			
			# actions
			
			def start_element_namespace(name, attrs = [], prefix = nil, uri = nil, ns = [])
				if @in_rpr
					@run_properties.start_element_namespace(name, attrs, prefix, uri, ns)
					return
				end
				
				if @drawing
					@drawing.start_element_namespace(name, attrs, prefix, uri, ns)
					return
				end
				
				if @in_t
					return
				end
			
				if uri != XML::DOC_NS
					return
				end
				
				case name
				when 'rPr'
					@in_rpr = true
				when 'drawing'
					@drawing = Drawing.new
				when 't'
					@string = ''
					@in_t = true
				when 'br'
					@children << "\n"
					puts "run>>> br"
				else
					puts "run>>> #{name} #{attrs.inspect} #{prefix} #{uri} #{ns.inspect}"
				end
			end
		
			def end_element_namespace(name, prefix = nil, uri = nil)
				if @in_rpr
					if (name == 'rPr') && (uri == XML::DOC_NS)
						@in_rpr = false
						return
					end
					
					@run_properties.end_element_namespace(name, prefix, uri)
					return
				end
				
				if @drawing
					if (name == 'drawing') && (uri == XML::DOC_NS)
						@children << @drawing
						puts "drawing>> #{@drawing.ref_id}"
						@drawing = nil
						return
					end
					
					@drawing.end_element_namespace(name, prefix, uri)
					return
				end
				
				if @in_t
					if (name == 't') && (uri == XML::DOC_NS)
						@in_t = false
						@children << @string
						puts "run>>> text: '#{@string}'"
						@string = nil
					end
					
					return
				end

				if uri != XML::DOC_NS
					return
				end
				
				case name
				when 'br'
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