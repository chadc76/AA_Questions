require 'rspec'
require 'question_like'
require 'question_database'

describe QuestionLike do 
  before(:each) { QuestionDatabase.reset! }
  after(:each) { QuestionDatabase.reset! }
  
end 
