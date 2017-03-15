require 'rails_helper'

RSpec.describe Submission, type: :model do
  describe 'judge method works correct' do
    let(:contest) do
      create(:contest_holding, score_baseline: 1,
                               start_at: DateTime.new(2017, 3, 14, 21, 0o0, 0o0),
                               end_at: DateTime.new(2017, 3, 14, 22, 40, 0o0))
    end
    let(:user) do
      create(:user) do |user|
        create(:contest_registration, contest: contest,
                                      user: user)
      end
    end
    let(:data_set) do
      create(:data_set, problem: contest.problems.first,
                        score: 100)
    end
    let(:submission) do
      create(:submission, user: user,
                          data_set: data_set,
                          judge_status: :waiting,
                          answer: answer,
                          created_at: submitted_at,
                          updated_at: submitted_at)
    end

    shared_examples 'updated properly' do
      it 'judge_status and score' do
        submission.judge
        expect(submission.judge_status).to eq expected_judge_status
        expect(submission.score).to eq expected_score
      end
    end

    context 'when submission is correct' do
      let(:answer) { data_set.output }
      let(:expected_judge_status) { 'accepted' }

      context 'when score is full score of the data_set and' do
        let(:submitted_at) { DateTime.new(2017, 3, 14, 21, 0o0, 0o0) }
        let(:expected_score) { 100 }
        it_behaves_like 'updated properly'
      end

      context 'when score is half score of the data_set and' do
        let(:submitted_at) { DateTime.new(2017, 3, 14, 21, 50, 0o0) }
        let(:expected_score) { 75 }
        it_behaves_like 'updated properly'
      end

      context 'when score is half score of the data_set and' do
        let(:submitted_at) { DateTime.new(2017, 3, 14, 22, 40, 0o0) }
        let(:expected_score) { 50 }
        it_behaves_like 'updated properly'
      end
    end

    context 'when submission is wrong' do
      let(:answer) { data_set.output + ' + This is wrong answer' }
      let(:submitted_at) { DateTime.new(2017, 3, 14, 21, 0o0, 0o0) }
      let(:expected_judge_status) { 'wrong' }
      let(:expected_score) { 0 }
      it_behaves_like 'updated properly'
    end
  end
end
