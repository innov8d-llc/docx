module DOCX
	module MD
		class Heading
			
			def initialize(para)
				@para = para
			end
			
			def to_s
				("#" * @para.heading_level) + " #{@para.runs.map { |run| Span.new(run) }.join('')}\n\n"
			end
			
		end
	end
end