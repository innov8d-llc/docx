module DOCX
	module MD
		class Code
			
			def initialize(para)
				@para = para
			end
			
			def to_s
				"\t #{@para.runs.map { |run| Span.new(run) }.join('')}\n"
			end
			
		end
	end
end