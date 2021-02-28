require 'rspec'
require 'modelbase'
require 'question_follow'
require 'reply'
require 'question_like'

describe ModelBase do 
  
  before(:each) { QuestionDatabase.reset! }
  after(:each) { QuestionDatabase.reset! }
end 
