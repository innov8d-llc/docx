require 'docx/version'
require 'docx/archive'
require 'docx/relations'
require 'docx/xml'
require 'docx/md'
require 'docx/document'
require 'fileutils'

module DOCX
	def self.parse(filename)
		DOCX.new(filename)
	end
	
	class DOCX
		
		def initialize(filename)
			@archive = Archive.new(filename)
			
			@relations = get_relations
			@document = get_document
			
			extract_images
		end
		
		# accessors
		
		def archive
			@archive
		end
		
		def images
			@relations.images
		end
		
		def links
			@relations.links
		end
		
		private
		
		def get_relations
			
			if !@archive.has_file?('word/_rels/document.xml.rels')
				raise 'Invalid docx file.'
			end

			file = @archive.get('word/_rels/document.xml.rels')
			rels = Relations.new(file)
			file.close
			
			rels
		end
		
		def get_document
			
			if !@archive.has_file?('word/document.xml')
				raise 'Invalid docx file.'
			end

			file = @archive.get('word/document.xml')
			outfile = File.open('output.md', 'w')
			document = Document.new(file, outfile, @relations)
			outfile.close
			file.close
			
			document
		end		
		
		def extract_images
			images.each do |image|
				target = image[:target]
				puts "* Extracting #{target}"
				dir = File.dirname(target)
				FileUtils.mkdir_p(dir) unless File.exist?(dir)
				file = @archive.get("word/#{target}")
				File.open(target, 'wb') do |f|
					f << file.read
				end
				file.close
			end
		end
		
	end
	
end