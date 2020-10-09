# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Maigofuda::Railtie do
  context 'when default config' do
    describe 'ActionController::Base' do
      describe '.included_modules' do
        it { expect(ActionController::Base.included_modules).to be_include Maigofuda::ErrorHandler }
      end

      describe '.rescue_handlers' do
        it { expect(ActionController::Base.rescue_handlers).to be_include ['Maigofuda::BaseError', :maigofuda] }
      end
    end
  end
end
