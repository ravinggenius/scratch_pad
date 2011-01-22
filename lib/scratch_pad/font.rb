module ScratchPad
  class Font
    attr_reader :name

    def initialize(name, directory, license, &block)
      @name, @directory, @license = name, Pathname.new(directory), license
      @files = []
      yield self
    end

    def add_file(file_name)
      @files << file_name
    end

    def files
      @files.map { |file| @directory + file }
    end

    def files_by_extension
      reply = {}
      files.each do |file|
        extension = file.extname.sub('.', '').to_sym
        reply[extension] = file
      end
      reply
    end

    def license
      if @license
        @directory + (@license.is_a?(String) ? @license : 'license.txt')
      end
    end
  end
end
