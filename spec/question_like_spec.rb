require 'rspec'
require 'question_like'
require 'question_database'

describe QuestionLike do 
  before(:each) { QuestionDatabase.reset! }
  after(:each) { QuestionDatabase.reset! }
  
  describe '::likers_for_question_id' do
    subject(:likers) { described_class.likers_for_question_id(4) }

    it 'only hits the database once' do 
      expect(QuestionDatabase).to receive(:execute).exactly(1).times.and_call_original
      described_class.likers_for_question_id(1)
    end

    it 'returns an array of instances of user class' do
      expect(likers).to all( be_an(User) )
    end

    it 'returns correct likers for the question' do 
      expect(likers.map(&:id)).to match_array([2, 3, 4, 5, 6])
    end
  end

  describe '::num_likes_for_question_id' do
    subject(:num_likes) { described_class.num_likes_for_question_id(4) }

    it 'only hits the database once' do 
      expect(QuestionDatabase).to receive(:get_first_value).exactly(1).times.and_call_original
      described_class.num_likes_for_question_id(1)
    end

    it 'returns correct number of likes for the question' do
      expect(num_likes).to eq(5)
    end
  end

  describe '::liked_questions_for_user_id' do
    subject(:questions) { described_class.liked_questions_for_user_id(2) }

    it 'only hits the database once' do 
      expect(QuestionDatabase).to receive(:execute).exactly(1).times.and_call_original
      described_class.liked_questions_for_user_id(1)
    end

    it 'returns an array of instances of the question class' do
      expect(questions).to all( be_an(Question) )
    end

    it 'returns correct questions liked by the user' do
      expect(questions.map(&:id)).to match_array([1, 3, 4])
    end
  end

  describe '::most_liked_questions' do
    subject(:most_liked) { described_class.most_liked_questions(1) }
    let(:top_three) { described_class.most_liked_questions(3) }

    it 'only hits the database once' do 
      expect(QuestionDatabase).to receive(:execute).exactly(1).times.and_call_original
      described_class.most_liked_questions(1)
    end

    it 'returns an array of instances of the question class' do
      expect(most_liked).to all( be_an(Question) )
    end

    it 'returns correct questions liked by the user' do
      expect(most_liked.map(&:id)).to match_array([4])
      expect(top_three.map(&:id)).to match_array([4, 3, 2])
    end
  end

end 
