module DOCX
	
	module XML
		
		class Paragraph
		
			def initialize(attrs)
				@runs = []
				@run = nil
				@in_ppr = false
				@paragraph_properties = ParagraphProperties.new
			end
			
			# accessors
			
			def style
				@paragraph_properties.style
			end
			
			def is_heading?
				if style.nil?
					return false
				end
				
				!style.match(/^Heading/).nil?
			end
			
			def heading_level
				if !is_heading?
					return nil
				end
				
				level = style[7,style.length - 7]
				level = level.to_i
				
				if level < 1
					level = 1
				elsif level > 6
					level = 6
				end
				
				level
			end
			
			def is_list?
				!@paragraph_properties.num_properties.nil?
			end
			
			def indent_level
				if !is_list?
					return nil
				end
				
				@paragraph_properties.num_properties.indent_level
			end
			
			def is_code?
				if style.nil?
					return false
				end
				
				(style == "Program") || (style == "Code")
			end
			
			def is_quote?
				if style.nil?
					return false
				end

				style == "Quote"
			end
			
			def runs
				@runs
			end
		
			# actions

			def start_element_namespace(name, attrs = [], prefix = nil, uri = nil, ns = [])
				if @in_ppr
					@paragraph_properties.start_element_namespace(name, attrs, prefix, uri, ns)
					return
				end
				
				if @run
					@run.start_element_namespace(name, attrs, prefix, uri, ns)
					return
				end

				if uri != XML::DOC_NS
					return
				end
			
				case name
				when 'pPr'
					@in_ppr = true
				when 'r'
					puts 'NEW RUN'
					@run = Run.new
					add_run(@run)
				else
					puts "P>>> #{name} #{attrs.inspect} #{prefix} #{uri} #{ns.inspect}"
				end
			end
		
			def end_element_namespace(name, prefix = nil, uri = nil)
				
				if @in_ppr
					if (name == 'pPr') && (uri == XML::DOC_NS)
						@in_ppr = false
						return
					end
					
					@paragraph_properties.end_element_namespace(name, prefix, uri)
					return
				end
				
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

				puts "P>>> /#{name} #{prefix} #{uri}"
			end
			
			def characters(string)
				if @run
					@run.characters(string)
				end
			end
		
			def add_run(run)
				@runs << run
			end
		
		end
		
	end

end