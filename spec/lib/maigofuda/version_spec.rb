# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Maigofuda::Version do
  describe '.string' do

    context 'without args' do
      subject(:exec_string) { described_class.string }

      context 'when MAJOR => 9, MINOR => 8, TINY => 7, PRE => nil' do
        before do
          stub_const 'Maigofuda::Version::MAJOR', 9
          stub_const 'Maigofuda::Version::MINOR', 8
          stub_const 'Maigofuda::Version::TINY', 7
          stub_const 'Maigofuda::Version::PRE', nil
        end

        it { is_expected.to eq '9.8.7' }
      end

      context 'when MAJOR => 4, MINOR => 5, TINY => 6, PRE => "rc1"' do
        before do
          stub_const 'Maigofuda::Version::MAJOR', 4
          stub_const 'Maigofuda::Version::MINOR', 5
          stub_const 'Maigofuda::Version::TINY', 6
          stub_const 'Maigofuda::Version::PRE', 'rc1'
        end

        it { is_expected.to eq '4.5.6.rc1' }
      end
    end

    context 'with args => "1234"' do
      subject(:exec_string) { described_class.string '1234' }

      context 'when MAJOR => 9, MINOR => 8, TINY => 7, PRE => nil' do
        before do
          stub_const 'Maigofuda::Version::MAJOR', 9
          stub_const 'Maigofuda::Version::MINOR', 8
          stub_const 'Maigofuda::Version::TINY', 7
          stub_const 'Maigofuda::Version::PRE', nil
        end

        it { is_expected.to eq '9.8.7.build1234' }
      end

      context 'when MAJOR => 4, MINOR => 5, TINY => 6, PRE => "rc.1"' do
        before do
          stub_const 'Maigofuda::Version::MAJOR', 4
          stub_const 'Maigofuda::Version::MINOR', 5
          stub_const 'Maigofuda::Version::TINY', 6
          stub_const 'Maigofuda::Version::PRE', 'rc1'
        end

        it { is_expected.to eq '4.5.6.rc1.build1234' }
      end

    end
  end

  describe 'Maigofuda' do
    subject { Maigofuda }

    it { is_expected.to be_const_defined :VERSION }

    describe ':VERSION' do
      subject(:const_version) { Maigofuda::VERSION }

      it { is_expected.to match(/^(?:0|[1-9]\d*)\.(?:0|[1-9]\d*)\.(?:0|[1-9]\d*)(?:\.\w+)?(?:\.build\w+)?$/) }
    end
  end
end
