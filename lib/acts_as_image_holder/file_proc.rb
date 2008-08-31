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
      safe_file_name options, file, field
    end
    
    # guesses the thumb-filename
    def guess_thumb_file_name(options, file, field=nil, i=0)
      safe_file_name options, file, field, "thumb#{i==0?'':i}"
    end
    
    # guess original file-name
    def guess_original_file_name(options, file)
      safe_file_name options, file, nil, 'orig'
    end
    
    # writes down the file
    def write_file(options, file_name, file_data)
      dirname = options.directory + "/" + (file_name.include?('/') ? file_name[0, file_name.rindex('/')] : '')
      FileUtils.mkdir_p dirname
      File.open(options.directory+"/"+file_name, 'wb') do |file|
        file.write file_data
      end
    end
    
    # removes the file
    def remove_file(options, file_name)
      FileUtils.rm_rf options.directory + "/" + file_name if file_name and file_name != ''
    end
    
  private
    # generates a safe file-name depend on the given file-name
    def safe_file_name(options, file, field=nil, suffix=nil)
      # creating a clean file-name
      file_name = file.respond_to?(:original_filename) ? file.original_filename : File.basename(file.path)
      file_name = file_name[0, file_name.rindex('.')]+".#{field.type}" if field and field.type
      
      # putting in the suffix
      if suffix
        file_name = file_name[0, file_name.rindex('.')]+"-#{suffix}"+
          file_name[file_name.rindex('.'), file_name.size]
      end
      
      # creating subdirectory name
      directory_name = if options.subdirs
                         options.subdirs.is_a?(Proc) ? options.subdirs.call()+"/" :
                           Time.now.strftime(options.subdirs)+"/"
                       else ''
                       end
      
      while File.exists? options.directory + "/" + directory_name + file_name
        file_name = rand(9).to_s + file_name # <- unshifting a random prefix untill it's safe
      end
      
      directory_name + file_name
    end
  end
end
