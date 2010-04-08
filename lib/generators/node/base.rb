require 'rails/generators/named_base'

module Node
  module Generators
    class Base < Rails::Generators::NamedBase
      def self.source_root
        #@source_root ||= File.expand_path('../templates', __FILE__)
        @source_root ||= begin
          File.expand_path(File.join(Dir.pwd, generator_name, 'templates')) if generator_name
        end
      end
    end
  end
end
