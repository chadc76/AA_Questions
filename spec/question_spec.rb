require 'rspec'
require 'question' 
require 'question_database' 

describe Question do 
  before(:each) { QuestionDatabase.reset! }
  after(:each) { QuestionDatabase.reset! }
  
  describe '::find_by_author_id' do
    subject(:author_questions) { described_class.find_by_author_id(2) }
    
    it 'returns an array of instances of the question class' do
      expect(author_questions).to all( be_an(described_class))
    end

    it "returns only questions with the correct author id's" do
      author_ids = author_questions.map { |q| q.author_id }
      expect(author_ids).to all( eq(2) )
    end
  end

  describe '::most_followed' do
    let(:questionfollow) { class_double("QuestionFollow").as_stubbed_const }

    it 'calls QuestionFollow::most_followed_questions' do
      expect(questionfollow).to receive(:most_followed_questions).with(1)
      described_class.most_followed(1)
    end
  end

  describe '::most_liked' do
    let(:questionlike) { class_double("QuestionLike").as_stubbed_const }

    it 'calls QuestionLike::most_liked_questions' do
      expect(questionlike).to receive(:most_liked_questions).with(1)
      described_class.most_liked(1)
    end
  end

  describe '#author' do
    subject(:question) { described_class.find_by_id(1) }
    let(:user) { class_double("User").as_stubbed_const }

    it 'calls User::find_by_id' do
      expect(user).to receive(:find_by_id).with(question.author_id)
      question.author
    end
  end

  describe '#replies' do
    subject(:question) { described_class.find_by_id(1) }
    let(:reply) { class_double("Reply").as_stubbed_const }

    it 'calls Reply::find_by_question_id' do
      expect(reply).to receive(:find_by_question_id).with(question.id)
      question.replies
    end
  end

  describe '#followers' do
    subject(:question) { described_class.find_by_id(1) }
    let(:questionfollow) { class_double("QuestionFollow").as_stubbed_const }

    it 'calls QuestionFollow::follower_for_question_id' do
      expect(questionfollow).to receive(:followers_for_question_id).with(question.id)
      question.followers
    end
  end

  describe '#likers' do
    subject(:question) { described_class.find_by_id(1) }
    let(:questionlike) { class_double("QuestionLike").as_stubbed_const }

    it 'calls QuestionLike::liker_for_question_id' do
      expect(questionlike).to receive(:likers_for_question_id).with(question.id)
      question.likers
    end
  end

  describe '#num_likes' do
    subject(:question) { described_class.find_by_id(1) }
    let(:questionlike) { class_double("QuestionLike").as_stubbed_const }

    it 'calls QuestionLike::num_likes_for_question_id' do
      expect(questionlike).to receive(:num_likes_for_question_id).with(question.id)
      question.num_likes
    end
  end
end
