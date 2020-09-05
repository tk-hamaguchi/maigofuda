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
    default_injection = Maigofuda.configuration.injection_error_class
    yield
    Maigofuda.configuration.injection_error_class = default_injection
    reload_module(const_symbol, const_path)
  end
end
