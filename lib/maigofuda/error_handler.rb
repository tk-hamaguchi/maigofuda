# frozen_string_literal: true

module Maigofuda

  #
  # エラーハンドラ
  #
  # @version 0.1.0
  # @since   0.1.0
  #
  module ErrorHandler
    extend ActiveSupport::Concern
    include ActiveSupport::Callbacks

    included { define_callbacks :maigofuda }

    #
    # Maigofuda::BaseErrorとそのサブクラスに対するハンドラ
    #
    # @param [Maigofuda::BaseError] exception Maigofuda::BaseErrorおよびそのサブクラスのエラーオブジェクト
    #
    def maigofuda(exception)
      request[:maigofuda_error] = exception

      run_callbacks :maigofuda do
        __maigofuda_logging exception, { sync_backtrace_level: __maigofuda_important?(exception) }

        render json: exception, status: exception.status_code
      end
    end

    def maigofuda_error
      request[:maigofuda_error]
    end

    #
    # ClassMethods
    #
    module ClassMethods
      %i[before after around].each do |callback|
        define_method "#{callback}_maigofuda" do |*callback_names, &blk|
          callback_names.push(blk).compact.each do |callback_name|
            set_callback(:maigofuda, callback, callback_name)
          end
        end
      end
    end

    private

    #
    # エラーの内容をログに出力する
    #
    # @param [Maigofuda::BaseError] error ログに記録するエラー
    # @param [Hash] options オプション
    # @option options [Boolean] :sync_backtrace_level backtraceをエラーメッセージと同様のログレベルで出力する
    #
    def __maigofuda_logging(error, options = {})
      Rails.logger.add(__maigofuda_log_level_sym_to_const(error.log_level), __maigofuda_format_log_message(error))
      return true unless error.print_backtrace?

      backtrace_level = options.fetch(:sync_backtrace_level, false) ? error.log_level : :debug
      backtrace_level_const = __maigofuda_log_level_sym_to_const(backtrace_level)
      error.backtrace&.each { |line| Rails.logger.add(backtrace_level_const, line) }

      true
    end

    def __maigofuda_log_level_sym_to_const(log_level)
      ::Logger.const_get(log_level.to_s.upcase.to_sym)
    end

    def __maigofuda_format_log_message(error)
      [
        __maigofuda_prepend_error_message(error),
        log_prefix(error),
        log_message(error),
        log_suffix(error)
      ].reject(&:blank?).join('  ')
    end

    def __maigofuda_prepend_error_message(error)
      prepend_error_message = []

      prepend_error_message << "<#{error.error_code}>" if Maigofuda.print_error_code? && error.error_code.present?
      prepend_error_message << error.class.name if Maigofuda.print_error_class?

      prepend_error_message.compact.join(' ')
    rescue StandardError => e
      Rails.logger.warn "#{e.class.name} (#{e.message})"

      nil
    end

    def __maigofuda_important?(exception)
      %i[warn info debug].exclude?(exception.log_level)
    end

    def log_prefix(_exception)
      nil
    end

    def log_message(exception)
      exception.message
    end

    def log_suffix(_exception)
      nil
    end

  end
end
