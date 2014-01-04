module DOCX
	module XML
		class RunProperties < Generic
			
			def initialize
				@style = nil
				@bold = false
				@italics = false
				@underline = false
			end
			
			# accessors
			
			def italics
				@italics
			end
			
			def bold
				@bold
			end
			
			# actions
			
			def start_element_namespace(name, attrs = [], prefix = nil, uri = nil, ns = [])
				if uri != XML::DOC_NS
					return
				end
			
				case name
				when 'rStyle'
					@style = get_attr('val', XML::DOC_NS, attrs)
					puts "rPr>>> style: #{@style}"
				when 'b'
					@bold = true
					puts "rPr>>> bold"
				when 'i'
					@italics = true
					puts "rPr>>> italics"
				when 'u'
					@underline = true
					puts "rPr>>> underline"
				when 'noProof'
				else
					puts "rPr>>> #{name} #{attrs.inspect} #{prefix} #{uri} #{ns.inspect}"
				end
			end
		
			def end_element_namespace(name, prefix = nil, uri = nil)
				if uri != XML::DOC_NS
					return
				end
			
				case name
				when 'rStyle'
				when 'b'
				when 'i'
				when 'u'
				when 'noProof'
				else
					puts "rPr>>> /#{name} #{prefix} #{uri}"
				end
			end
			
		end
	end
end