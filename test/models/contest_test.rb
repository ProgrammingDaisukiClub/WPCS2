require 'test_helper'

class ContestTest < ActiveSupport::TestCase
  test "should create a contest object" do
    assert_not_nil Contest.create!(name_ja: 'n_ja', name_en: 'n_en', description_ja: 'd_ja', description_en: 'd_en', start_at: DateTime.now, end_at: DateTime.now, score_baseline: 10)
  end
end
