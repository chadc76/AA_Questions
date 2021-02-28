require 'rspec'
require 'reply' 
require 'question_database' 

describe Reply do 
  
  before(:each) { QuestionDatabase.reset! }
  after(:each) { QuestionDatabase.reset! }

  describe '::find_by_user_id' do
    subject(:user_replies) { described_class.find_by_user_id(1) }

    it 'returns an array of instances of the reply class' do
      expect(user_replies).to all( be_an(described_class) )
    end

    it 'returns only replies with the correct user id' do
      user_ids = user_replies.map { |r| r.user_id }
      expect(user_ids).to all( eq(1) )
    end
  end

  describe '::find_by_question_id' do
    subject(:question_replies) { described_class.find_by_question_id(1) }

    it 'returns an array of instances of the reply class' do
      expect(question_replies).to all( be_an(described_class) )
    end

    it 'returns only replies witht the correct question id' do
      question_ids = question_replies.map { |r| r.subject_question_id }
      expect(question_ids).to all( eq(1) )
    end
  end

  describe '#author' do
    subject(:reply) { described_class.find_by_id(1) }
    let(:user) { class_double("User").as_stubbed_const }

    it 'calls User::find_by_id' do 
      expect(user).to receive(:find_by_id).with(reply.user_id)
      reply.author
    end
  end

  
  describe '#question' do
    subject(:reply) { described_class.find_by_id(1) }
    let(:question) { class_double("Question").as_stubbed_const }

    it 'calls Question::find_by_id' do 
      expect(question).to receive(:find_by_id).with(reply.subject_question_id)
      reply.question
    end
  end  
  
  describe '#parent_reply' do
    subject(:reply) { described_class.find_by_id(1) }

    it 'calls Reply::find_by_id' do 
      expect(described_class).to receive(:find_by_id).with(reply.parent_reply_id)
      reply.parent_reply
    end
  end

  describe 'child_replies' do
    subject(:reply1) { described_class.find_by_id(7) }
    let(:reply2) { described_class.find_by_id(9) }

    it 'returns an array of instances of reply class' do
      children1 = reply1.child_replies
      children2 = reply2.child_replies
      expect(children1). to all( be_an(described_class) )
      expect(children2). to all( be_an(described_class) )
    end

    it 'returns only replies with the correct id' do
      children1 = reply1.child_replies
      children2 = reply2.child_replies
      parent_ids1 = children1.map { |c| c.parent_reply_id }
      parent_ids2 = children2.map { |c| c.parent_reply_id }
      expect(parent_ids1).to all( eq(7) )
      expect(parent_ids2).to all( eq(9) )
    end

    it 'does not return the child replies of its child replies' do
      children = reply1.child_replies
      children_ids = children.map { |c| c.id }
      expect(children_ids).to_not include (10)
    end
  end

end 
