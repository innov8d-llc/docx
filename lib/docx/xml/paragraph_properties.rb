module DOCX
	
	module XML
		
		class ParagraphProperties < Generic
			
			def initialize
				@style = nil
				@jc = nil
				@in_rpr = false
				@in_numpr = false
				@run_properties = RunProperties.new
				@num_properties = nil
			end
			
			# accessors
			
			def style
				@style
			end
			
			def num_properties
				@num_properties
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
				
				if @in_numpr
					@num_properties.start_element_namespace(name, attrs, prefix, uri, ns)
					return
				end
			
				case name
				when 'pStyle'
					@style = get_attr('val', XML::DOC_NS, attrs)
					puts "pPr>>> style: #{@style}"
				when 'jc'
					@jc = get_attr('val', XML::DOC_NS, attrs)
					puts "pPr>>> justification: #{@jc}"
				when 'rPr'
					@in_rpr = true
				when 'numPr'
					@in_numpr = true
					@num_properties = NumberingProperties.new
				else
					puts "pPr>>> #{name} #{attrs.inspect} #{prefix} #{uri} #{ns.inspect}"
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

				if @in_numpr
					if name == 'numPr'
						@in_numpr = false
						puts "pPr>>> numPr>> ilvl: #{@num_properties.indent_level} numId: #{@num_properties.num_id}"
						return
					end
					
					@num_properties.end_element_namespace(name, prefix, uri)
					return
				end
			
				case name
				when 'jc'
				when 'pStyle'
				else
					puts "pPr>>> /#{name} #{prefix} #{uri}"
				end
			end
			
		end
		
	end
	
end