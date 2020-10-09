# frozen_string_literal: true

module Maigofuda
  module Generators

    #
    # ファイルインストール用ジェネレータ
    #
    # @version 0.1.0
    # @since   0.1.0
    #
    class InstallGenerator < ::Rails::Generators::Base
      desc <<~DESC
        Description:
            Copy maigofuda files to your application.
      DESC

      source_root File.expand_path('templates', __dir__)

      def copy_config
        template 'config/initializers/maigofuda.rb'
        template 'config/locales/maigofuda.en.yml'
      end

      def exec_rebuild
        rake 'maigofuda:rebuild'
      end
    end
  end
end
