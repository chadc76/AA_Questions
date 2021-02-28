require 'rspec'
require 'user' 
require 'question_database' 

describe User do

  before(:each) { QuestionDatabase.reset! }
  after(:each) { QuestionDatabase.reset! }
  
  describe '::find_by_name' do
    it 'returns an instance of the user class' do 
      reply = described_class.find_by_name('Ned', 'Stark')
      expect(reply).to be_kind_of(described_class)
    end

    it 'returns the correct fname and lname' do
      reply = described_class.find_by_name('Ned', 'Stark')
      expect(reply.fname).to eq('Ned')
      expect(reply.lname).to eq('Stark')
    end

    it 'should accept name as "fname lname" or ("fname", "lname")' do
      reply1 = described_class.find_by_name('Ned', 'Stark')
      reply2 = described_class.find_by_name('Ned Stark')
      expect(reply1.id).to eq(reply2.id)
    end

    it 'only looks for the first row in the users table' do
      expect(QuestionDatabase).to receive(:get_first_row).exactly(1).times.and_call_original
      described_class.find_by_name('Ned', 'Stark')
    end
  end

  describe '#authored_questions' do
    subject(:user) { described_class.find_by_id(1) }
    let(:question) { class_double("Question").as_stubbed_const }

    it 'calls Question::find_by_author_id' do
      expect(question).to receive(:find_by_author_id).with(user.id)
      user.authored_questions
    end
  end

  describe '#authored_replies' do
    subject(:user) { described_class.find_by_id(1) }
    let(:reply) { class_double("Reply").as_stubbed_const }

    it 'calls Reply::find_by_user_id' do
      expect(reply).to receive(:find_by_user_id).with(user.id)
      user.authored_replies
    end 
  end

  describe 'followed_questions' do
    subject(:user) { described_class.find_by_id(1) }
    let(:questionfollow) { class_double("QuestionFollow").as_stubbed_const }
  
    it 'calls QuestionFollow::followed_questions' do
      expect(questionfollow).to receive(:followed_questions_for_user_id).with(user.id)
      user.followed_questions
    end 
  end

    describe '#liked_questions' do
    subject(:user) { described_class.find_by_id(1) }
    let(:questionlike) { class_double("QuestionLike").as_stubbed_const }
  
    it 'calls QuestionLike::liked_questions_for_user_id' do
      expect(questionlike).to receive(:liked_questions_for_user_id).with(user.id)
      user.liked_questions
    end 
  end

  describe '#average_karma' do
    it 'returns correct average karma for a user' do  
      user = described_class.find_by_id(1)
      expect(user.average_karma).to eq(3.5)
    end

    it 'only hits the database once' do 
      user = described_class.find_by_id(2)
      expect(QuestionDatabase).to receive(:get_first_value).exactly(1).times.and_call_original
      user.average_karma
    end
  end

end
