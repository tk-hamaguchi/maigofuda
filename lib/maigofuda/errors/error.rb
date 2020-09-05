# frozen_string_literal: true

module Maigofuda

  #
  # エラーレベルのエラーに対する基底クラス
  #
  # @version 0.1.0
  # @since   0.1.0
  #
  class Error < Maigofuda.injection_error_class

    #
    # コンストラクタ
    #
    # @param [Exception,String] message エラーオブジェクトまたはエラーメッセージ
    # @param [Hash] options オプション
    # @option options [<Type>] :source エラーの元となったオブジェクト
    #
    def initialize(message, options = {})
      self.log_level = :error
      super message, options
    end
  end
end
