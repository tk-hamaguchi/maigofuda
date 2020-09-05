# frozen_string_literal: true

module Maigofuda

  #
  # 404 NotFound を伴うエラーの基底クラス
  #
  # @version 0.1.0
  # @since   0.1.0
  #
  class NotFoundError < Warning

    #
    # コンストラクタ
    #
    # @param [Object] message エラーオブジェクトまたはエラーメッセージ
    # @param [Hash] options オプション
    # @option options [Exception] :source エラーの元となったオブジェクト
    #
    def initialize(message, options = {})
      self.status_code = Rack::Utils::SYMBOL_TO_STATUS_CODE[:not_found]
      super message, options
    end
  end
end
