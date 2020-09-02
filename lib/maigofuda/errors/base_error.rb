# frozen_string_literal: true

module Maigofuda

  #
  # エラーの規定クラス
  #
  # @version 0.1.0
  # @since   0.1.0
  #
  class BaseError < RuntimeError
    include ActiveModel::Serializers::JSON

    # @return [Exception,nil] エラーの元となったオブジェクト
    attr_accessor :source

    # @return [Integer] レスポンスステータスコード
    attr_accessor :status_code

    # @return [String] アプリケーションが管理するエラーコード
    attr_writer :error_code

    # @return [Symbol] エラーのログレベル
    attr_accessor :log_level

    # @return [Object] attributesを取り出す時の設定値
    attr_accessor :errors

    # @return [Boolean] backtraceを出すべきかどうかの設定値
    attr_accessor :print_backtrace

    #
    # コンストラクタ
    #
    # @param [Exception,String] message エラーオブジェクトまたはエラーメッセージ
    # @param [Hash] options オプション
    # @option options [<Type>] :source エラーの元となったオブジェクト
    #
    def initialize(message, options = {})
      self.source          ||= options[:source]
      self.log_level       ||= :unknown
      self.status_code     ||= 500
      self.errors          ||= message
      self.print_backtrace = true if print_backtrace.nil?

      super message
    end

    #
    # オブジェクトの属性ハッシュ
    #
    # @return [Hash] オブジェクトの属性ハッシュ
    #
    def attributes
      { errors: errors }
    end

    #
    # アプリケーション内で管理しているエラーコードを返す
    #
    # @return [String] アプリケーション内で管理しているエラーコード
    #
    # @raise [KeyError] エラーコード定義ファイルに対応するエラーコードが定義されていない
    #
    def error_code
      @error_code ||= Maigofuda.configuration.error_code_table.fetch self.class.name
    end

    #
    # i18nでローカライズされたメッセージを返す
    #
    # @param [Hash] options ローカライズする際のオプション
    # @return [String] ローカライズされたメッセージ
    #
    # @note ja.yaml
    #    ja:
    #      error_messages:
    #        hoge_error: 'Hogeeee!'
    #
    def localized_message(options = {})
      I18n.t("maigofuda.error_messages.#{self.class.name.underscore.tr('/', '.')}", **options)
    end

    #
    # バックトレースをログに記録するべきかどうか
    #
    # @return [Boolean] バックトレースをログに記録するべきかどうか
    #
    def print_backtrace?
      (print_backtrace == true)
    end

  end
end
