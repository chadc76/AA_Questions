require 'rspec'
require 'question_follow'
require 'question_database.rb'

describe QuestionFollow do 
  
  before(:each) { QuestionDatabase.reset! }
  after(:each) { QuestionDatabase.reset! }
  
  describe 'QuestionFollow::followers_for_question_id' do
    subject(:followers) { described_class.followers_for_question_id(4) } 

    it 'only hits the database once' do
      expect(QuestionDatabase).to receive(:execute).exactly(1).times.and_call_original
      described_class.followers_for_question_id(1) 
    end

    it 'returns an array of instances of the user class' do
      expect(followers).to all( be_an(User) )
    end

    it 'returns the correct followers for the question' do
      expect(followers.map(&:id)).to match_array([1, 2, 3, 4, 5, 6])
    end
  end

  describe 'QuestionFollow::followed_questions_for_user_id' do
    subject(:questions) { described_class.followed_questions_for_user_id(3) } 

    it 'only hits the database once' do
      expect(QuestionDatabase).to receive(:execute).exactly(1).times.and_call_original
      described_class.followed_questions_for_user_id(1) 
    end

    it 'returns an array of instances of the question class' do
      expect(questions).to all( be_an(Question) )
    end

    it 'returns the correct questions followed by user' do
      expect(questions.map(&:id)).to match_array([3, 1, 2, 4])
    end
  end

  describe 'QuestionFollow::most_followed_questions' do
    subject(:most_followed) { described_class.most_followed_questions(1) } 
    let(:top_three) { described_class.most_followed_questions(3) } 

    it 'only hits the database once' do
      expect(QuestionDatabase).to receive(:execute).exactly(1).times.and_call_original
      described_class.most_followed_questions(1) 
    end

    it 'returns an array of instances of the question class' do
      expect(most_followed).to all( be_an(Question) )
      expect(top_three).to all( be_an(Question) )
    end

    it 'returns the correct questions followed by user' do
      expect(most_followed.map(&:id)).to match_array([4])
      expect(top_three.map(&:id)).to match_array([4, 3, 2])
    end
  end
end 
