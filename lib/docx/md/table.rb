module DOCX
	module MD
		class Table
			
			def initialize(table, relations = nil)
				@table = table
				@relations = relations
			end
			
			def to_s
				output = []
				
				if (@table.columns > 0) && (@table.rows.length > 0)
					output << "<table>\n"
					
					header_row = @table.has_header_row? ? @table.rows.shift : nil
					footer_row = @table.has_footer_row? ? @table.rows.pop : nil
					
					if header_row
						output << "<thead>\n"
						output << "<tr>\n"
						header_row.each do |col|
							output << "<th markdown=\"1\">#{MD::Paragraph.new(col,@relations).to_s}</th>\n"
						end
						output << "</tr>\n"
						output << "</thead>\n"
					end
					
					output << "<tbody>\n"
					@table.rows.each do |row|
						output << "<tr>\n"
						
						row.each do |col|
							output << "<td markdown=\"1\">#{MD::Paragraph.new(col,@relations).to_s}</td>\n"
						end
						
						output << "</tr>\n"
					end
					output << "</tbody>\n"
					
					if footer_row
						output << "<tfoot>\n"
						output << "<tr>\n"
						footer_row.each do |col|
							output << "<th markdown=\"1\">#{MD::Paragraph.new(col,@relations).to_s}</th>\n"
						end
						output << "</tr>\n"
						output << "</tfoot>\n"
					end
					
					output << "</table>\n"
				end
				
				output.join('')
			end
		end
	end
end