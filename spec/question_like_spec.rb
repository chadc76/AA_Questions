require 'rspec'
require_relative '../question_like'
require_relative '../questions_database'

describe QuestionLike do 
  before(:each) { QuestionsDatabase.reset! }
  after(:each) { QuestionsDatabase.reset! }
  
end 
