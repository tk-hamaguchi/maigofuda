# frozen_string_literal: true

RSpec.describe Maigofuda do

  let(:config) { instance_double Maigofuda::Config }

  before { allow(Maigofuda::Config).to receive(:instance).and_return(config) }

  it { expect(described_class).to be_a Module }
  it { expect(described_class).not_to be_a Class }

  describe '.setup' do
    subject(:exec_setup) { described_class.setup {} }

    before do
      allow(described_class).to receive(:configuration).and_return(config)
      allow(config).to receive(:configured=).and_return(true)
    end

    it { expect { |b| described_class.setup(&b) }.to yield_with_args config }

    describe 'configuration' do
      before { exec_setup }

      it { expect(config).to have_received(:configured=).with(true) }
    end
  end

  describe '.configuration' do
    subject { described_class.configuration }

    it { is_expected.to eq config }
  end

  describe '.configured?' do
    subject { described_class.configured? }

    before { allow(config).to receive(:configured).and_return(configured) }

    context 'when configuration.configured => true' do
      let(:configured) { true }

      it { is_expected.to eq true }
    end

    context 'when configuration.configured => false' do
      let(:configured) { false }

      it { is_expected.to eq false }
    end

    context 'when configuration.configured => nil' do
      let(:configured) { nil }

      it { is_expected.to eq false }
    end
  end

  describe '.auto_load?' do
    subject { described_class.auto_load? }

    before { allow(config).to receive(:auto_load).and_return(auto_load) }

    context 'when configuration.auto_load => true' do
      let(:auto_load) { true }

      it { is_expected.to eq true }
    end

    context 'when configuration.auto_load => false' do
      let(:auto_load) { false }

      it { is_expected.to eq false }
    end

    context 'when configuration.auto_load => nil' do
      let(:auto_load) { nil }

      it { is_expected.to eq false }
    end
  end

  describe '.print_error_code?' do
    subject { described_class.print_error_code? }

    before { allow(config).to receive(:print_error_code).and_return(print_error_code) }

    context 'when configuration.print_error_code => true' do
      let(:print_error_code) { true }

      it { is_expected.to eq true }
    end

    context 'when configuration.print_error_code => false' do
      let(:print_error_code) { false }

      it { is_expected.to eq false }
    end

    context 'when configuration.print_error_code => nil' do
      let(:print_error_code) { nil }

      it { is_expected.to eq false }
    end
  end

  describe '.print_error_class?' do
    subject { described_class.print_error_class? }

    before { allow(config).to receive(:print_error_class).and_return(print_error_class) }

    context 'when configuration.print_error_class => true' do
      let(:print_error_class) { true }

      it { is_expected.to eq true }
    end

    context 'when configuration.print_error_class => false' do
      let(:print_error_class) { false }

      it { is_expected.to eq false }
    end

    context 'when configuration.print_error_class => nil' do
      let(:print_error_class) { nil }

      it { is_expected.to eq false }
    end
  end

  describe '.injection_error_class' do
    subject { described_class.injection_error_class }

    before { allow(config).to receive(:injection_error_class).and_return(injection_error_class) }

    context 'when configuration.injection_error_class => "Maigofuda::BaseError"' do
      let(:injection_error_class) { 'Maigofuda::BaseError' }

      it { is_expected.to eq Maigofuda::BaseError }
    end

    context 'when configuration.injection_error_class => "RuntimeError"' do
      let(:injection_error_class) { 'RuntimeError' }

      it { is_expected.to eq RuntimeError }
    end
  end
end
