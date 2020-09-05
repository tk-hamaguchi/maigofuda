# frozen_string_literal: true

require 'maigofuda/railtie'

#
# 迷子札の基底モジュール
#
# @version 0.1.0
# @since   0.1.0
#
module Maigofuda
  extend ActiveSupport::Autoload

  autoload :Config

  eager_autoload do
    autoload :BaseError,                'maigofuda/errors/base_error'
    autoload :Warning,                  'maigofuda/errors/warning'
    autoload :BadRequestError,          'maigofuda/errors/bad_request_error'
    autoload :UnauthorizedError,        'maigofuda/errors/unauthorized_error'
    autoload :ForbiddenError,           'maigofuda/errors/forbidden_error'
    autoload :NotFoundError,            'maigofuda/errors/not_found_error'
    autoload :ConflictError,            'maigofuda/errors/conflict_error'
    autoload :PreconditionFailedError,  'maigofuda/errors/precondition_failed_error'
    autoload :UnprocessableEntityError, 'maigofuda/errors/unprocessable_entity_error'
    autoload :LockedError,              'maigofuda/errors/locked_error'
    autoload :Error,                    'maigofuda/errors/error'
    autoload :InternalServerError,      'maigofuda/errors/internal_server_error'
    autoload :ServiceUnavailableError,  'maigofuda/errors/service_unavailable_error'
    autoload :Fatal,                    'maigofuda/errors/fatal'
  end

  #
  # Maigofuda::Configを使ってセットアップを実施する
  #
  # @yieldparam [Maigofuda::Config] configuration 設定オブジェクト
  #
  def self.setup
    yield configuration

    configuration.configured = true
  end

  #
  # 設定オブジェクト
  #
  # @return [Maigofuda::Config] 設定オブジェクトを取得する
  #
  def self.configuration
    Maigofuda::Config.instance
  end

  #
  # セットアップが完了しているかどうか
  #
  # @return [Boolean] セットアップが完了している場合はtrue
  #
  def self.configured?
    (configuration.configured.present? && configuration.configured == true)
  end

  #
  # オートロードを実行するかどうか
  #
  # @return [Boolean] 自動でActionControllerにincludeする場合はtrue
  #
  def self.auto_load?
    (configuration.auto_load == true)
  end

  #
  # ログにエラーコードを出力するかどうか
  #
  # @return [Boolean] ログにエラーコードを出力する場合はtrue
  #
  def self.print_error_code?
    (configuration.print_error_code == true)
  end

  #
  # ログにエラーメッセージを出力するかどうか
  #
  # @return [Boolean] ログにエラーメッセージを出力する場合はtrue
  #
  def self.print_error_class?
    (configuration.print_error_class == true)
  end

  #
  # エラーの基底クラス
  #
  # @return [Class] エラーの基底となるクラス
  #
  def self.injection_error_class
    configuration.injection_error_class.constantize
  end
end
