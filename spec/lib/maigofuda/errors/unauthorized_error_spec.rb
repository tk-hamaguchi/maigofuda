# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Maigofuda::UnauthorizedError do
  subject(:described_instance) { described_class.new(*args) }

  let(:args) { ['hoge', { source: source }] }
  let(:source) { instance_double(RuntimeError) }
  let(:configuration) { instance_double(Maigofuda::Config, error_code_table: error_code_table) }
  let(:error_code_table) { {} }

  before { allow(Maigofuda).to receive(:configuration).and_return(configuration) }

  describe 'super class' do
    it { expect(described_class.superclass).to eq Maigofuda::Warning }
  end

  its(:log_level) { is_expected.to eq :warn }
  its(:status_code) { is_expected.to eq 401 }
  its(:print_backtrace?) { is_expected.to eq true }

  describe '#error_code' do
    subject(:exec_error_code) { described_instance.error_code }

    context 'when error_code_table => {}' do
      let(:error_code_table) { {} }

      it { expect { exec_error_code }.to raise_error KeyError }
    end

    context 'when error_code_table => { "Maigofuda::UnauthorizedError" => "U123" }' do
      let(:error_code_table) { { 'Maigofuda::UnauthorizedError' => 'U123' } }

      it { is_expected.to eq 'U123' }
    end
  end

  describe '#localized_message' do
    let(:translations) { {} }

    before do
      I18n.backend.send :init_translations
      I18n.backend.store_translations I18n.locale, translations
    end

    after do
      I18n.reload!
      I18n.backend.send :init_translations
    end

    context 'without args' do
      subject { described_instance.localized_message }

      context 'when "en.maigofuda.error_messages.maigofuda.unauthorized_error" => "Hoge"' do
        let(:translations) { { maigofuda: { error_messages: { maigofuda: { unauthorized_error: 'Hoge' } } } } }

        it { is_expected.to eq 'Hoge' }
      end
    end
  end
end
