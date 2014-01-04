module DOCX
	module XML
		class Generic
			def get_attr(name, uri, attrs)
				if attrs.nil?
					return ""
				end
			
				attr = attrs.select { |attr| (attr.localname == name) && (attr.uri == uri) }.first
			
				if attr.nil?
					return ""
				end
			
				attr.value
			end
			
		end
	end
end
