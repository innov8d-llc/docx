require 'nokogiri'

module DOCX
	class Relations

		def initialize(file)
			doc = Nokogiri::XML(file)
			@relations = doc.xpath("//rel:Relationship", rel: 'http://schemas.openxmlformats.org/package/2006/relationships').map do |rel|
				{
					id: rel['Id'],
					type: rel['Type'],
					target: rel['Target'],
					target_mode: rel['TargetMode']
				}
			end
		end
		
		# accessors
		
		def relations
			@relations
		end
		
		def images
			relations.select { |rel| rel[:type] == 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/image' }
		end
		
		def links
			relations.select { |rel| rel[:type] == 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink' }
		end
		
	end
end