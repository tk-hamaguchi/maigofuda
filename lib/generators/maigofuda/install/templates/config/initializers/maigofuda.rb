# frozen_string_literal: true

Maigofuda.setup do |config|

  # Include Maigofuda::ErrorHandler and append rescue_from to ActionController::Base and ActionController::API.
  # config.auto_load = true

  # Specify when you want to inject the default error class directly under the Maigofuda::BaseError.
  #   Example:
  #     class YourCustomError < Maigofuda::BaseError
  #       attr_accessor :special_text
  #
  #       def attributes
  #         super.mege(special_text: special_text)
  #       end
  #     end
  #
  #     Maigofuda.setup do |config|
  #       config.injection_error_class = '::YourCustomError'
  #     end
  #
  # config.injection_error_class = '::Maigofuda::BaseError'

  # Print error code to log.  Error code is resolved by `config/error_codes.yml`
  # config.print_error_code = true

  # Print error class name to log.
  # config.print_error_class = true

end
