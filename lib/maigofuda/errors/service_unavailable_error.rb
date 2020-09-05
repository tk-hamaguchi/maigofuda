# frozen_string_literal: true

module Maigofuda

  #
  # 503 Service unavailable を伴うエラーの基底クラス
  #
  # @version 0.1.0
  # @since   0.1.0
  #
  class ServiceUnavailableError < Error

    #
    # コンストラクタ
    #
    # @param [Object] message エラーオブジェクトまたはエラーメッセージ
    # @param [Hash] options オプション
    # @option options [Exception] :source エラーの元となったオブジェクト
    #
    def initialize(message, options = {})
      self.status_code = Rack::Utils::SYMBOL_TO_STATUS_CODE[:service_unavailable]
      super message, options
    end
  end
end
