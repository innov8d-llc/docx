module DOCX
	module XML
		class Drawing < Generic
			
			DRAWING_URI = 'http://schemas.openxmlformats.org/drawingml/2006/main'
			PICTURE_URI = 'http://schemas.openxmlformats.org/drawingml/2006/picture'
			
			def initialize
				@in_graphic = false
				@in_graphic_data = false
				@in_pic = false
				@in_blip_fill = false
				@ref_id = nil
			end
			
			# accessors
			
			def ref_id
				@ref_id
			end
			
			# actions
			
			def start_element_namespace(name, attrs = [], prefix = nil, uri = nil, ns = [])
				if (uri != DRAWING_URI) && (uri != PICTURE_URI)
					return
				end
			
				if (uri == DRAWING_URI)
					case name
					when 'graphic'
						puts "drawing >> in graphic"
						@in_graphic = true
					when 'graphicData'
						if @in_graphic
							puts "drawing >> in graphic data"
							@in_graphic_data = true
						end
					when 'blip'
						if @in_blip_fill
							puts "drawing >> in blip"
							@ref_id = get_attr('embed', 'http://schemas.openxmlformats.org/officeDocument/2006/relationships', attrs)
						end
					else
						puts "drawing>>> #{name} #{attrs.inspect} #{prefix} #{uri} #{ns.inspect}"
					end
					
					return
				end
				
				if (uri == PICTURE_URI)
					case name
					when 'pic'
						if @in_graphic_data
							puts "drawing >> in pic"
							@in_pic = true
						end
					when 'blipFill'
						if @in_pic
							puts "drawing >> in blipFill"
							@in_blip_fill = true
						end
					else
						puts "drawing>>> #{name} #{attrs.inspect} #{prefix} #{uri} #{ns.inspect}"
					end
					
					return
				end
			end
		
			def end_element_namespace(name, prefix = nil, uri = nil)
				if (uri != XML::DOC_NS) && (uri != DRAWING_URI) && (URI != PICTURE_URI)
					return
				end

				if (uri == DRAWING_URI)
					case name
					when 'graphic'
						@in_graphic = false
					when 'graphicData'
						@in_graphic_data = false
					when 'blip'
					else
						puts "drawing>>> /#{name} #{prefix}"
					end
					
					return
				end

				if (uri == PICTURE_URI)
					case name
					when 'pic'
						@in_pic = false
					when 'blipFill'
						@in_blip_fill = false
					else
						puts "drawing>>> #{name} #{attrs.inspect} #{prefix} #{uri} #{ns.inspect}"
					end
				end
			end
			
		end
	end
end