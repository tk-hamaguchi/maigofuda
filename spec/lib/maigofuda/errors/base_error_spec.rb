# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Maigofuda::BaseError do
  subject(:described_instance) { described_class.new(*args) }

  let(:args) { ['hoge', { source: source }] }
  let(:source) { instance_double(RuntimeError) }
  let(:configuration) { instance_double(Maigofuda::Config, error_code_table: error_code_table) }
  let(:error_code_table) do
    {
      'Maigofuda::BaseError' => 'X999999999'
    }
  end

  before do
    allow(Maigofuda).to receive(:configuration).and_return(configuration)
  end

  it { is_expected.to respond_to :source }
  it { is_expected.to respond_to :source= }
  it { is_expected.to respond_to :status_code }
  it { is_expected.to respond_to :status_code= }
  it { is_expected.to respond_to :error_code }
  it { is_expected.to respond_to :error_code= }
  it { is_expected.to respond_to :log_level }
  it { is_expected.to respond_to :log_level= }
  it { is_expected.to respond_to :errors }
  it { is_expected.to respond_to :errors= }
  it { is_expected.to respond_to :print_backtrace }
  it { is_expected.to respond_to :print_backtrace= }
  it { is_expected.to respond_to :print_backtrace? }
  it { is_expected.to respond_to :attributes }

  describe 'constructor' do
    context 'with "hoge"' do
      let(:args) { ['hoge'] }

      its(:source) { is_expected.to be_nil }
      its(:status_code) { is_expected.to eq 500 }
      its(:error_code) { is_expected.to eq 'X999999999' }
      its(:log_level) { is_expected.to eq :unknown }
      its(:errors) { is_expected.to eq 'hoge' }
      its(:print_backtrace) { is_expected.to eq true }
      its(:attributes) { is_expected.to eq({ errors: 'hoge' }) }
      its(:to_json) { is_expected.to eq '{"errors":"hoge"}' }
    end

    context 'with "hoge", source: DOUBLE' do
      let(:args) { ['hoge', { source: source }] }

      its(:source) { is_expected.to eq source }
      its(:status_code) { is_expected.to eq 500 }
      its(:error_code) { is_expected.to eq 'X999999999' }
      its(:log_level) { is_expected.to eq :unknown }
      its(:errors) { is_expected.to eq 'hoge' }
      its(:print_backtrace) { is_expected.to eq true }
      its(:attributes) { is_expected.to eq({ errors: 'hoge' }) }
      its(:to_json) { is_expected.to eq '{"errors":"hoge"}' }
    end
  end

  describe '#error_code' do
    context 'when error_code_table => {}' do
      subject(:exec_error_code) { described_instance.error_code }

      let(:error_code_table) do
        {}
      end

      it { expect { exec_error_code }.to raise_error KeyError }
    end

    context 'when error_code_table => { "Maigofuda::BaseError" => "A123" }' do
      subject { described_instance.error_code }

      let(:error_code_table) do
        {
          'Maigofuda::BaseError' => 'A123'
        }
      end

      it { is_expected.to eq 'A123' }
    end
  end

  describe '#attributes' do
    subject { described_instance.attributes }

    before { described_instance.errors = errors }

    context 'when @errors => nil' do
      let(:errors) { nil }

      it { is_expected.to eq({ errors: nil }) }
    end

    context 'when @errors => "Hoge"' do
      let(:errors) { 'Hoge' }

      it { is_expected.to eq({ errors: 'Hoge' }) }
    end

    context 'when @errors => ["Hoge"]' do
      let(:errors) { ['Hoge'] }

      it { is_expected.to eq({ errors: ['Hoge'] }) }
    end

    context 'when @errors => { message: "Hoge"}' do
      let(:errors) { { message: 'Hoge' } }

      it { is_expected.to eq({ errors: { message: 'Hoge' } }) }
    end
  end

  describe '#to_json' do
    subject { described_instance.to_json }

    before { described_instance.errors = errors }

    context 'when @errors => nil' do
      let(:errors) { nil }

      it { is_expected.to eq '{"errors":null}' }
    end

    context 'when @errors => "Hoge"' do
      let(:errors) { 'Hoge' }

      it { is_expected.to eq '{"errors":"Hoge"}' }
    end

    context 'when @errors => ["Hoge"]' do
      let(:errors) { ['Hoge'] }

      it { is_expected.to eq '{"errors":["Hoge"]}' }
    end

    context 'when @errors => { message: "Hoge"}' do
      let(:errors) { { message: 'Hoge' } }

      it { is_expected.to eq '{"errors":{"message":"Hoge"}}' }
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

    # rubocop:disable Style/FormatStringToken

    context 'without args' do
      subject { described_instance.localized_message }

      context 'when "en.maigofuda.error_messages.maigofuda.base_error" => "Hoge"' do
        let(:translations) { { maigofuda: { error_messages: { maigofuda: { base_error: 'Hoge' } } } } }

        it { is_expected.to eq 'Hoge' }
      end

      context 'when "en.maigofuda.error_messages.maigofuda.base_error" => "Ho%{param}ge"' do
        let(:translations) { { maigofuda: { error_messages: { maigofuda: { base_error: 'Ho%{param}ge' } } } } }

        it { is_expected.to eq 'Ho%{param}ge' }
      end
    end

    context 'with args => (hoge: "fuga")' do
      subject { described_instance.localized_message(args) }

      let(:args) { { hoge: 'fuga' } }

      context 'when "en.maigofuda.error_messages.maigofuda.base_error" => "Hoge"' do
        let(:translations) { { maigofuda: { error_messages: { maigofuda: { base_error: 'Hoge' } } } } }

        it { is_expected.to eq 'Hoge' }
      end

      context 'when "en.maigofuda.error_messages.maigofuda.base_error" => "Ho%{hoge}ge"' do
        let(:translations) { { maigofuda: { error_messages: { maigofuda: { base_error: 'Ho%{hoge}ge' } } } } }

        it { is_expected.to eq 'Hofugage' }
      end
    end
  end

  # rubocop:enable Style/FormatStringToken

  describe '#print_backtrace?' do
    context 'when print_backtrace => true' do
      subject { described_instance.print_backtrace? }

      before { described_instance.print_backtrace = true }

      it { is_expected.to eq true }
    end

    context 'when print_backtrace => false' do
      subject { described_instance.print_backtrace? }

      before { described_instance.print_backtrace = false }

      it { is_expected.to eq false }
    end
  end
end
