module DOCX
	
	module XML
		
		class Table < Generic
		
			def initialize
				@rows = []
				@in_tbl_grid = false
				@in_table_pr = false
				@columns = 0
				@cur_column = 0
				@row = nil
				@para = nil
				@header_row = false
				@footer_row = false
			end
			
			# accessors
			
			def columns
				@columns
			end
			
			def rows
				@rows
			end
			
			def has_header_row?
				@header_row
			end
			
			def has_footer_row?
				@footer_row
			end
		
			# actions

			def start_element_namespace(name, attrs = [], prefix = nil, uri = nil, ns = [])
				if @para
					@para.start_element_namespace(name, attrs, prefix, uri, ns)
					return
				end

				if uri != XML::DOC_NS
					return
				end
			
				case name
				when 'tblPr'
					@in_table_pr = true
				when 'tblLook'
					if @in_table_pr
						@header_row = get_attr('firstRow', 'http://schemas.openxmlformats.org/wordprocessingml/2006/main', attrs) == "1"
						@footer_row = get_attr('lastRow', 'http://schemas.openxmlformats.org/wordprocessingml/2006/main', attrs) == "1"
					end
				when 'tblGrid'
					@in_tbl_grid = true
				when 'gridCol'
					if (@in_tbl_grid)
						@columns += 1
					end
				when 'tr'
					@row = []
					@cur_column = 0
				when 'tc'
				when 'tcPr'
				when 'p'
					@para = Paragraph.new(attrs)
				else
					puts "TABLE>>> #{name} #{attrs.inspect} #{prefix} #{uri} #{ns.inspect}"
				end
			end
		
			def end_element_namespace(name, prefix = nil, uri = nil)
				
				if @para
					if (name == 'p') && (uri == XML::DOC_NS)
						@row[@cur_column] = @para
						@para = nil
						return
					end
					
					@para.end_element_namespace(name, prefix, uri)
					return
				end
				
				if uri != XML::DOC_NS
					return
				end

				case name
				when 'tblPr'
				when 'tblGrid'
					@in_tbl_grid = false
				when 'gridCol'
				when 'tr'
					@rows << @row
				when 'tc'
					@cur_column += 1
				when 'tcPr'
				else
					puts "TABLE>>> /#{name} #{prefix} #{uri}"
				end
			end
		
			def characters(string)
				if @para
					@para.characters(string)
				end
			end
		
		end
		
	end

end