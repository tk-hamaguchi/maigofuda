# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Maigofuda::ErrorHandler do
  let(:included_class) do
    Class.new do
      include Maigofuda::ErrorHandler

      def request
        @request ||= {}
      end

      def render(options); end
    end
  end

  describe 'included class' do
    subject { included_class }

    it { is_expected.to respond_to :before_maigofuda }
    it { is_expected.to respond_to :after_maigofuda }
    it { is_expected.to respond_to :around_maigofuda }
  end

  describe 'included instance' do
    subject(:included_instance) { included_class.new }

    it { is_expected.to respond_to :maigofuda }
    it { is_expected.to respond_to :maigofuda_error }

    describe '#maigofuda' do
      subject(:exec_maigofuda) { included_instance.maigofuda exception }

      let(:logger) { instance_double(Logger).as_null_object }

      before do
        allow(included_instance).to receive(:render)
        allow(Rails).to receive(:logger).and_return(logger)
      end

      context 'with error that HogeClass(status_code => 999, log_level => :fatal, error_code => "A123", message => "Hoge", print_backtrace? => true, backtrace => %w[line1 line2 line3])' do # rubocop:disable Layout/LineLength
        before { exec_maigofuda }

        let(:exception) do
          instance_double Maigofuda::BaseError,
                          status_code: 999,
                          log_level: :fatal,
                          error_code: 'A123',
                          message: 'Hoge',
                          print_backtrace?: true,
                          backtrace: %w[line1 line2 line3],
                          class: instance_double(Class, name: 'HogeClass')
        end

        describe 'request[:maigofuda_error]' do
          subject { included_instance.request[:maigofuda_error] }

          it { is_expected.to eq exception }
        end

        describe '#maigofuda_error' do
          subject { included_instance.maigofuda_error }

          it { is_expected.to eq exception }
        end

        describe 'self' do
          it { expect(included_instance).to have_received(:render).with(json: exception, status: 999) }
        end

        describe 'Rails.logger' do
          it { expect(logger).to have_received(:add).with(::Logger::FATAL, '<A123> HogeClass  Hoge') }
          it { expect(logger).to have_received(:add).with(::Logger::FATAL, 'line1') }
          it { expect(logger).to have_received(:add).with(::Logger::FATAL, 'line2') }
          it { expect(logger).to have_received(:add).with(::Logger::FATAL, 'line3') }
        end
      end

      context 'with error that log_level => :warn' do
        before { exec_maigofuda }

        let(:exception) do
          instance_double Maigofuda::BaseError,
                          status_code: 999,
                          log_level: :warn,
                          error_code: 'A123',
                          message: 'Hoge',
                          print_backtrace?: true,
                          backtrace: %w[line1 line2 line3],
                          class: instance_double(Class, name: 'HogeClass')
        end

        describe 'Rails.logger' do
          it { expect(logger).to have_received(:add).with(::Logger::WARN, '<A123> HogeClass  Hoge') }
          it { expect(logger).to have_received(:add).with(::Logger::DEBUG, 'line1') }
          it { expect(logger).to have_received(:add).with(::Logger::DEBUG, 'line2') }
          it { expect(logger).to have_received(:add).with(::Logger::DEBUG, 'line3') }
        end
      end

      context 'with error that log_level => :debug and print_backtrace? => false' do
        before { exec_maigofuda }

        let(:exception) do
          instance_double Maigofuda::BaseError,
                          status_code: 999,
                          log_level: :debug,
                          error_code: 'A123',
                          message: 'Hoge',
                          print_backtrace?: false,
                          backtrace: %w[line1 line2 line3],
                          class: instance_double(Class, name: 'HogeClass')
        end

        describe 'Rails.logger' do
          it { expect(logger).to have_received(:add).with(::Logger::DEBUG, '<A123> HogeClass  Hoge') }
          it { expect(logger).not_to have_received(:add).with(::Logger::DEBUG, 'line1') }
          it { expect(logger).not_to have_received(:add).with(::Logger::DEBUG, 'line2') }
          it { expect(logger).not_to have_received(:add).with(::Logger::DEBUG, 'line3') }
        end
      end
    end
  end
end

__END__
  let(:app) do
    Class.new(Rails::Application) do
      routes.append { get '/test' => 'test#exec' }
      config.consider_all_requests_local = true
      config.eager_load = true
      config.hosts = 'example.org'
    end
  end

  let(:test_controller) do
    Class.new(ActionController::API) do
      def exec
        render json: { hello: :world, configured: Maigofuda.configured? }
      end
    end
  end

  before do
    stub_const 'App', app
    stub_const 'TestController', test_controller

    Maigofuda.setup do |config|
      config.auto_load = false
    end

    App.initialize!
    @current_session = Rack::Test::Session.new(Rack::MockSession.new(App))
  end

  around do |example|
    al_paths      = ActiveSupport::Dependencies.autoload_paths
    al_once_paths = ActiveSupport::Dependencies.autoload_once_paths
    ActiveSupport::Dependencies.autoload_paths = []
    ActiveSupport::Dependencies.autoload_once_paths = []

    example.run

    ActiveSupport::Dependencies.autoload_paths      = al_paths
    ActiveSupport::Dependencies.autoload_once_paths = al_once_paths
  end


  
  #it { p subject.class.included_modules }
  it { p Rails.application }

  it do
    p @current_session.get('/test').body
    p Maigofuda.configured?
  end
end

__END__
  let(:described_class) do
    klass = Class.new(ActionController::Base) do
      include Maigofuda::ErrorHandler

      def index

      end
    end

    Rails.application.routes.draw do
      get '/index' => 
    end
    klass
  end

  it { }

end
