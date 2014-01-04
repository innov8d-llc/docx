module DOCX
	module XML
		class NumberingProperties < Generic
			
			def initialize
				@indent_level = nil
				@num_id = nil
			end
			
			# accessors
			
			def indent_level
				if @indent_level.nil?
					return 0
				end
				
				@indent_level.to_i
			end
			
			def num_id
				@num_id
			end
			
			# actions
			
			def start_element_namespace(name, attrs = [], prefix = nil, uri = nil, ns = [])
				if uri != XML::DOC_NS
					return
				end
			
				case name
				when 'ilvl'
					@indent_level = get_attr('val', XML::DOC_NS, attrs)
				when 'numId'
					@num_id = get_attr('val', XML::DOC_NS, attrs)
				else
					puts "numPr>>> #{name} #{attrs.inspect} #{prefix} #{uri} #{ns.inspect}"
				end
			end
		
			def end_element_namespace(name, prefix = nil, uri = nil)
				if uri != XML::DOC_NS
					return
				end
			
				case name
				when 'rStyle'
				when 'ilvl'
				when 'numId'
				else
					puts "numPr>>> /#{name} #{prefix} #{uri}"
				end
			end
			
		end
	end
end