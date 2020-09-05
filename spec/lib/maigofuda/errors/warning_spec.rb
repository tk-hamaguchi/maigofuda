# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Maigofuda::Warning do
  include ModuleReloader

  subject { described_class.new 'Hoge', {} }

  describe 'class' do
    subject(:described_class) { Maigofuda::Warning } # rubocop:disable RSpec/DescribedClass

    around do |example|
      around_reload(:Warning, 'lib/maigofuda/errors/warning.rb') do
        example.run
      end
    end

    context 'when Maigofuda.configuration.injection_error_class => "::Maigofuda::BaseError" (default)' do
      its(:superclass) { is_expected.to eq Maigofuda::BaseError }
    end

    context 'when Maigofuda.configuration.injection_error_class => "Hoge"' do
      before do
        stub_const 'Hoge', Class.new(Maigofuda::BaseError)
        Maigofuda.configuration.injection_error_class = Hoge.name
        reload_module(:Warning, 'lib/maigofuda/errors/warning.rb')
      end

      its(:superclass) { is_expected.to eq Hoge }
    end

    context 'when Maigofuda.configuration.injection_error_class => nil' do
      before do
        Maigofuda.configuration.injection_error_class = nil
        Maigofuda.send :remove_const, :Warning
      end

      it { expect { load 'lib/maigofuda/errors/warning.rb' }.to raise_error NoMethodError }
    end
  end

  its(:log_level) { is_expected.to eq :warn }
end
