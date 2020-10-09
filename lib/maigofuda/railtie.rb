# frozen_string_literal: true

module Maigofuda

  #
  # Railsエンジンの拡張
  #
  class Railtie < ::Rails::Railtie
    config.eager_load_namespaces << Maigofuda

    rake_tasks do
      load 'tasks/maigofuda_tasks.rake'
    end
  end
end

ActiveSupport.on_load(:action_controller) do
  if Maigofuda.configured? == false || Maigofuda.auto_load?
    include Maigofuda::ErrorHandler

    rescue_from Maigofuda::BaseError, with: :maigofuda
  end
end
