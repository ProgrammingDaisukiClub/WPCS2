require 'rails_helper'

RSpec.describe DataSet, type: :model do
  describe 'formatted_input method work properly' do
    let(:contest) { create(:contest_ended) }
    let(:problem) { contest.problems.first }
    let(:data_set) { create(:data_set, problem: problem, input: "1\r\n2\r3\n") }
    it 'new line codes unified LF' do
      expect(data_set.formatted_input).to eq "1\r\n2\r\n3\r\n"
    end
  end
end
