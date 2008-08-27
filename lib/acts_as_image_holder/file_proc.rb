require 'fileutils'
#
# this class handles the work with the files
#
# Copyright (C) by Nikolay V. Nemshilov aka St.
#
class ActsAsImageHolder::FileProc
  class << self
    # guesses the name for the file
    def guess_file_name(options, file, field=nil)
      file_name = file.respond_to?(:original_filename) ? file.original_filename : File.basename(file.path)
      file_name = file_name[0, file_name.rindex('.')]+".#{field.convert_to}" if field and field.convert_to
      
      safe_file_name options, file_name
    end
    
    # guesses the thmb-filename
    def guess_thmb_file_name(options, file, field=nil)
      file_name = file.respond_to?(:original_filename) ? file.original_filename : File.basename(file.path)
      file_name = file_name[0, file_name.rindex('.')]+"-thmb"+file_name[file_name.rindex('.'), file_name.size]
      file_name = file_name[0, file_name.rindex('.')]+".#{field.thmb_type}" if field and field.thmb_type
      
      safe_file_name options, file_name
    end
    
    # writes down the file
    def write_file(options, file_name, file_data)
      FileUtils.mkdir_p options.output_directory + "/" + (file_name.include?('/') ? file_name[0, file_name.rindex('/')] : '')
      File.open(options.output_directory+"/"+file_name, 'wb') do |file|
        file.write file_data
      end
    end
    
    # removes the file
    def remove_file(options, file_name)
      FileUtils.rm_rf options.output_directory + "/" + file_name if file_name and file_name != ''
    end
    
  private
    # generates a safe file-name depend on the given file-name
    def safe_file_name(options, file_name)
      directory_name = options.subdirectories ? Time.now.strftime(options.subdirectories)+"/" : ''
      
      while File.exists? options.output_directory + "/" + directory_name + file_name
        file_name = rand(9).to_s + file_name
      end
      
      directory_name + file_name
    end
  end
end
