require 'rspec'
require 'modelbase'
require 'question_follow'
require 'reply'
require 'question_like'
require 'question'

describe ModelBase do 
  
  before(:each) { QuestionDatabase.reset! }
  after(:each) { QuestionDatabase.reset! }

  describe '::table' do
    it 'correctly formats table names for multiple classes' do 
      expect(QuestionFollow.table).to eq('question_follows')
      expect(QuestionLike.table).to eq('question_likes')
    end
  end

  describe '::find_by_id' do 
    subject(:reply) { Reply.find_by_id(1) }
    let(:question) { Question.find_by_id(4) }

    context 'when called on different classes' do
      it 'returns correct instance the reply class' do
        expect(reply).to be_an(Reply)
        expect(reply.id).to eq(1)
      end

      it 'returns correct instance the question class' do
        expect(question).to be_an(Question)
        expect(question.id).to eq(4)
      end
    end
  end

  describe '::all' do
    subject(:reply) { Reply.all }
    let(:question) { Question.all }

    it 'returns an array of istances of any class thats called' do
      expect(reply).to all( be_an(Reply) )
    end

    it 'returns all the objects in that table' do 
      expect(reply.count).to eq(10)
    end

    context 'when called on different classes' do 
      it 'returns all replies' do 
        expect(reply).to all ( be_an(Reply) )
      end

      it 'returns all questions' do 
        expect(question).to all ( be_an(Question) )
      end
    end
  end

  describe '::where' do
    it 'searches for table column based on method name' do
      search1 = User.where("fname" => "Ned")
      expect(search1.first).to be_an(User)
      expect(search1.first.fname).to eq("Ned")
    end

    context 'when called on different classes' do 
      it 'filters replies based on parameters' do
        search1 = Reply.where("body" => "it's 6:34 man")
        expect(search1.first).to be_an(Reply)
      end

      it 'filters questions based on paramters' do 
        search2 = Question.where("title" => "Ned Question")
        expect(search2.first).to be_an(Question)
      end
    end 
  end 

  describe '::find_by' do 
    it "searches for the first name of a user" do 
      search1 = User.find_by(fname: "Ned")
      expect(search1.first).to be_an(User)
      expect(search1.first.fname).to eq("Ned")
      expect(search1.count).to eq(1)
    end 
    
    it 'searches for the body of a reply' do
      reply = Reply.find_by(body: "it's 6:34 man")
      expect(reply.first).to be_an(Reply)
      expect(reply.first.body).to eq("it's 6:34 man")
    end 
    
    it 'searches for the title of a question' do   
      question = Question.find_by(title: "Ned Question")
      expect(question.first).to be_an(Question)
      expect(question.first.title).to eq("Ned Question")
    end 
  end 
  
  describe '#create' do 
    let(:user) {User.new(
      {'fname' => "test_fname", 
       'lname' => "test_lname"}
    )}
    let(:reply) {Reply.new(
      {'user_id' => 1, 
       'body' => "body",'subject_question_id' => 1, 
       "parent_reply_id" => 1 }
    )}
    
    context 'when called on different classes' do 
      it 'creates a new user and persists it to the database' do 
        user.create
        expect(User.find_by_id(4)).to be_truthy 
      end
      
      it 'creates a new reply and persists it to the database' do 
        reply.save
        expect(Reply.find_by_id(11)).to be_truthy 
      end
    end 
  end 

  describe "#update" do 
    let(:user) {User.new(
      {'fname' => "test_fname", 
       'lname' => "test_lname"}
    )}
    let(:reply) {Reply.new(
      {'user_id' => 1, 
       'body' => "body",
       'subject_question_id' => 1, 
       "parent_reply_id" => 1 }
    )}

    context 'when called on different classes' do 
      it "updates a previously saved user's attributes" do 
        user.save
        user.fname = "updated_fname"
        user.save
        expect(User.find_by_id(7).fname).to eq("updated_fname")
      end 
    
      it "updates a previously saved reply's attributes" do 
        reply.save
        reply.body = "updated_body"
        reply.save
        expect(Reply.find_by_id(11).body).to eq("updated_body")
      end 
    end 
  end
end 
