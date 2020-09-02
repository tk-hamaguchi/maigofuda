# frozen_string_literal: true

module Maigofuda

  #
  # 設定オブジェクト
  #
  # @version 0.1.0
  # @since   0.1.0
  #
  class Config
    include ::Singleton

    # @return [Boolean] セットアップ済みかどうか
    attr_accessor :configured

    # @return [String] ベースクラス
    attr_accessor :injection_error_class

    # @return [Boolean] ActionControllerへの自動取込みフラグ
    attr_accessor :auto_load

    # @return [Boolean] エラーコードをログに出すフラグ
    attr_accessor :print_error_code

    # @return [Boolean] エラークラスをログに出すフラグ
    attr_accessor :print_error_class

    #
    # デフォルトの設定値をセットする
    #
    def set_default_value
      self.injection_error_class = '::Maigofuda::BaseError'
      self.auto_load             = true
      self.print_error_code      = true
      self.print_error_class     = true

      true
    end

    #
    # エラーコード表
    #
    # @return [Hash] エラーコード表を返す
    #
    def error_code_table
      @error_code_table ||= reload_error_code_table
    end

    #
    # エラーコード表の再取込みを実施する
    #
    # @return [Hash] エラーコード表
    #
    def reload_error_code_table
      @error_code_table = YAML.safe_load File.open(error_code_file)
      @error_code_table ||= {}
      @error_code_table
    end

    #
    # エラーコードファイルのパス
    #
    # @return [Pathname] エラーコードファイルのパス
    #
    def error_code_file
      Rails.root.join('config/error_codes.yml')
    end

    instance.set_default_value
  end
end
