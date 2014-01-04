module DOCX
	module MD
		class Paragraph
			
			def initialize(para)
				@para = para
			end
			
			def to_s
				css_class = ""
				
				if !(@para.style.nil? || @para.style.empty?)
					css_class = "\n{:.#{@para.style.downcase}}"
				end
				
				"#{@para.runs.map { |run| Span.new(run) }.join('')}#{css_class}\n\n"
			end
			
		end
	end
end