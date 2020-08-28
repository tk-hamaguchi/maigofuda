# frozen_string_literal: true

RSpec.describe Maigofuda do
  describe ':VERSION' do
    it 'is expected to match Semantic Versioning 2.0.0' do
      expect(described_class::VERSION).to match(/^(?:=|>=|<=|=>|=<|>|<|!=|~|~>|\^)?(?:0|[1-9]\d*)\.(?:0|[1-9]\d*)\.(?:0|[1-9]\d*)(?:-(?:(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+(?:[0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$/) # rubocop:disable Layout/LineLength
    end
  end
end
