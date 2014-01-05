module DOCX
	module MD
		class Span
			
			def initialize(run, relations = nil)
				@run = run
				@relations = relations
			end
			
			def to_s
				if @run.is_image?
					
					if @relations.nil?
						return ""
					end
					
					target = @relations.get_target(@run.image_id)
					
					if !target
						return ""
					end
					
					return "![](#{target})"
				end
				
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