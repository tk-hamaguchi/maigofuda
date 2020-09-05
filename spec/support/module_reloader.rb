# frozen_string_literal: true

module ModuleReloader
  def reload_module(const_symbol, const_path)
    begin
      Maigofuda.send :remove_const, const_symbol
    rescue NameError # rubocop:disable Lint/SuppressedException
    end

    load const_path
  end

  def around_reload(const_symbol, const_path, &_block)
    tmp_const = Maigofuda.const_get const_symbol
    default_injection = Maigofuda.configuration.injection_error_class
    yield
    Maigofuda.configuration.injection_error_class = default_injection
    begin
      Maigofuda.send :remove_const, const_symbol
    rescue NameError # rubocop:disable Lint/SuppressedException
    end
    Maigofuda.const_set const_symbol, tmp_const
  end
end
