# frozen_string_literal: true

module Maigofuda

  #
  # バージョン管理モジュール
  #
  # @version 0.1.0
  # @since   0.1.0
  #
  module Version

    # @return [Integer] メジャーバージョン
    MAJOR = 0

    # @return [Integer] マイナーバージョン
    MINOR = 1

    # @return [Integer] パッチバージョン
    TINY  = 0

    # @return [String,nil] リリース状況
    PRE   = nil

    #
    # バージョン文字列
    #
    # @param [String] build_version ビルドバージョン
    # @return [String] バージョンの文字列を返す
    #
    def self.string(build_version = nil)
      if !build_version.nil? && !build_version.empty? # rubocop:disable Rails/Present
        build_version = build_version.downcase.include?('build') ? build_version : "build#{build_version}"
      end

      [MAJOR, MINOR, TINY, PRE, build_version].compact.join('.')
    end

  end

  # @return [String] バージョン文字列
  VERSION = Version.string
end
