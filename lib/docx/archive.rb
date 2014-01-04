require 'zipruby'
require 'nokogiri'

module DOCX
	class Archive
		
		def initialize(filename)
			@archive = Zip::Archive.open(filename)
		end
		
		def filenames
			@filenames ||= get_filenames
		end
		
		def get(filename)
			@archive.fopen(filename)
		end
		
		def has_file?(filename)
			filenames.any? { |fname| fname == filename }
		end
		
		private
		
		def get_filenames
			@archive.map do |f|
				f.name
			end
		end
		
	end
end