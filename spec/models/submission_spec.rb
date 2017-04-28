require 'rails_helper'

RSpec.describe Submission, type: :model do
  describe 'judge method works correct' do
    let(:contest) do
      create(:contest_holding, score_baseline: 1,
                               start_at: Time.zone.parse('2017-3-14 21:00:00'),
                               end_at: Time.zone.parse('2017-03-14 22:40:00'))
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
        let(:submitted_at) { Time.zone.parse('2017-03-14 21:00:00') }
        let(:expected_score) { 100 }
        it_behaves_like 'updated properly'
      end

      context 'when score is half score of the data_set and' do
        let(:submitted_at) { Time.zone.parse('2017-03-14 21:50:00') }
        let(:expected_score) { 75 }
        it_behaves_like 'updated properly'
      end

      context 'when score is half score of the data_set and' do
        let(:submitted_at) { Time.zone.parse('2017-03-14 22:40:00') }
        let(:expected_score) { 50 }
        it_behaves_like 'updated properly'
      end
    end

    context 'when submission is correct and penalty' do
      let!(:wrong_answer) do
        create(:submission, user: user,
                            data_set: data_set,
                            judge_status: :wrong,
                            answer: answer,
                            created_at: submitted_at - 5.minute,
                            updated_at: submitted_at - 5.minute)
      end
      let!(:another_data_set) { contest.problems.second.data_sets.first }
      let!(:another_wrong_answer) do
        create(:submission, user: user,
                            data_set: another_data_set,
                            judge_status: :wrong,
                            answer: answer,
                            created_at: submitted_at - 10.minute,
                            updated_at: submitted_at - 10.minute)
      end
      let(:answer) { data_set.output }
      let(:expected_judge_status) { 'accepted' }

      context 'when score is half score of the data_set and' do
        let(:submitted_at) { Time.zone.parse('2017-03-14 21:00:00') }
        let(:expected_score) { 100 }
        it_behaves_like 'updated properly'
      end

      context 'when score is half score of the data_set and' do
        let(:submitted_at) { Time.zone.parse('2017-03-14 21:50:00') }
        let(:expected_score) { 75 }
        it_behaves_like 'updated properly'
      end

      context 'when score is half score of the data_set and' do
        let(:submitted_at) { Time.zone.parse('2017-03-14 22:40:00') }
        let(:expected_score) { 50 }
        it_behaves_like 'updated properly'
      end
    end

    context 'when submission is wrong' do
      let(:answer) { data_set.output + ' + This is wrong answer' }
      let(:submitted_at) { Time.zone.parse('2017-03-14 21:00:00') }
      let(:expected_judge_status) { 'wrong' }
      let(:expected_score) { 0 }
      it_behaves_like 'updated properly'
    end

    context 'after context is completed' do
      let(:answer) { data_set.output }
      let(:submitted_at) { Time.zone.parse('2017-03-14 23:00:00') }
      let(:expected_judge_status) { 'accepted' }
      let(:expected_score) { 0 }
      it_behaves_like 'updated properly'
    end
  end

  describe 'correct_answer? method works properly' do
    let(:contest) do
      create(:contest_holding, score_baseline: 1,
                               start_at: Time.zone.parse('2017-3-14 21:00:00'),
                               end_at: Time.zone.parse('2017-03-14 22:40:00'))
    end
    let(:user) do
      create(:user) do |user|
        create(:contest_registration, contest: contest,
                                      user: user)
      end
    end
    let(:data_set) do
      create(:data_set, problem: contest.problems.first,
                        score: 100,
                        output: data_set_output)
    end
    let(:submission) do
      create(:submission, user: user,
                          data_set: data_set,
                          judge_status: :waiting,
                          answer: answer)
    end

    context 'if the answer contains CRLF' do
      let(:data_set_output) { "1\n2\n3\n" }
      let(:answer) { "1\r\n2\r\n3\r\n" }

      it 'CRLF is identified as LF and return true' do
        expect(submission.correct_answer?).to eq true
      end
    end

    context 'if the answer contains continuous white space' do
      let(:data_set_output) { "1 2 3\n" }
      let(:answer) { "1   2\t\t\t   \t3\n" }

      it 'continuous white space is identified as a white space and return true' do
        expect(submission.correct_answer?).to eq true
      end
    end

    context 'if the answer contains trairing space character' do
      let(:data_set_output) { "1 2 3\n" }
      let(:answer) { "  1 2 3   \n  " }

      it 'trairing space character is ignored and return true' do
        expect(submission.correct_answer?).to eq true
      end
    end

    context 'if the answer is wrong' do
      let(:data_set_output) { "1 2 3\n" }
      let(:answer) { "1 2 4\n" }

      it 'return false' do
        expect(submission.correct_answer?).to eq false
      end
    end
  end
end
