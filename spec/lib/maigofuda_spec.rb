# frozen_string_literal: true

RSpec.describe Maigofuda do
  it { expect(described_class).to be_a Module }
  it { expect(described_class).not_to be_a Class }
end
