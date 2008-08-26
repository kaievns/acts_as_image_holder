#
# this class handles the work with the files
#
class ActsAsImageHolder::FileProc
  class << self
    # guesses the name for the file
    def guess_file_name(options, field, file)
    end
    
    # guesses the thmb-filename
    def guess_thmb_file_name(options, field, file)
    end
    
    # writes down the file
    def write_file(options, file_name, file_data)
    end
    
    # removes the file
    def remove_file(options, file_name)
    end
  end
end
