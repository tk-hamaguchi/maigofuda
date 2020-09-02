# frozen_string_literal: true

RSpec.describe Maigofuda::Config do
  subject(:described_instance) { described_class.instance }

  it { is_expected.to respond_to :configured }
  it { is_expected.to respond_to :configured= }
  it { is_expected.to respond_to :injection_error_class }
  it { is_expected.to respond_to :injection_error_class= }
  it { is_expected.to respond_to :auto_load }
  it { is_expected.to respond_to :auto_load= }
  it { is_expected.to respond_to :print_error_code }
  it { is_expected.to respond_to :print_error_code= }
  it { is_expected.to respond_to :print_error_class }
  it { is_expected.to respond_to :print_error_class= }
  it { is_expected.to respond_to :set_default_value }
  it { is_expected.to respond_to :error_code_table }
  it { is_expected.to respond_to :reload_error_code_table }
  it { is_expected.to respond_to :error_code_file }

  its(:injection_error_class) { is_expected.to eq '::Maigofuda::BaseError' }
  its(:auto_load) { is_expected.to eq true }
  its(:print_error_code) { is_expected.to eq true }
  its(:print_error_class) { is_expected.to eq true }

  describe '#error_code_file' do
    subject { described_instance.error_code_file }

    its(:to_s) { is_expected.to eq File.expand_path('../../dummy/config/error_codes.yml', __dir__) }
  end

  describe '#reload_error_code_table' do
    subject(:exec_reload_error_code_table) { described_instance.reload_error_code_table }

    let(:yaml_hash) { instance_double Hash }
    let(:file) { instance_double File }

    before do
      allow(YAML).to receive(:safe_load).and_return(yaml_hash)
      allow(File).to receive(:open).and_return(file)
    end

    it { is_expected.to eq yaml_hash }

    describe '@error_code_table' do
      subject { described_instance.instance_variable_get :@error_code_table }

      before { exec_reload_error_code_table }

      context 'when load data is nil' do
        let(:yaml_hash) { nil }

        it { is_expected.to eq({}) }
      end

      context 'when load data is { "Hoge" => "A123" }' do
        let(:yaml_hash) { { 'Hoge' => 'A123' } }

        it { is_expected.to eq(yaml_hash) }
      end
    end
  end

  describe '#error_code_table' do
    subject(:exec_error_code_table) { described_instance.error_code_table }

    let(:error_code_table) { instance_double(Hash) }

    before { allow(described_instance).to receive(:reload_error_code_table).and_return(error_code_table) }

    context 'when @error_code_table => nil' do
      before { described_instance.instance_variable_set :@error_code_table, nil }

      it { is_expected.to eq(error_code_table) }

      describe 'self' do
        before { exec_error_code_table }

        it { expect(described_instance).to have_received :reload_error_code_table }
      end
    end

    context 'when @error_code_table => :hoge' do
      before { described_instance.instance_variable_set :@error_code_table, :hoge }

      it { is_expected.to eq :hoge }

      describe 'self' do
        before { exec_error_code_table }

        it { expect(described_instance).not_to have_received :reload_error_code_table }
      end
    end
  end
end
