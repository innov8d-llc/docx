module DOCX
	module MD
		class Span
			
			def initialize(run)
				@run = run
			end
			
			def to_s
				text = @run.text
				text.gsub!("\n","  \n")
				
				if @run.italics
					text = "**#{text}**"
				elsif @run.bold
					text = "*#{text}*"
				end
				
				text
			end
			
		end
	end
end