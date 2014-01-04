module DOCX
	module MD
		class ListItem
			
			def initialize(para)
				@para = para
			end
			
			def to_s
				("   " * @para.indent_level) + "* #{@para.runs.map { |run| Span.new(run) }.join('')}\n"
			end
			
		end
	end
end