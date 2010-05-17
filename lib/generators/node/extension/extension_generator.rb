require 'generators/node/base.rb'
require 'rails/generators/resource_helpers'

module Node
  module Generators
    class ExtensionGenerator < Node::Generators::Base
      include Rails::Generators::ResourceHelpers

      def create_root_folder
        #empty_directory File.join(, controller_file_path)
      end

      def copy_model_file
        filename = "#{model}.rb"
        template filename, File.join(extensions_root, controller_file_path, filename)
      end

      def copy_view_files
        [
          :form,
          :full,
          :preview
        ].each do |view|
          filename = "_#{view}.html.haml"
          template filename, File.join(extensions_root, controller_file_path, filename)
        end
      end

      protected

      def extensions_root
        'lib/node_extensions'
      end
    end
  end
end
