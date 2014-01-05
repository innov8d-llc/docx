module DOCX
	module MD
		class Quote
			
			def initialize(para)
				@para = para
			end
			
			def to_s
				"> #{@para.runs.map { |run| Span.new(run) }.join('')}\n"
			end
			
		end
	end
end