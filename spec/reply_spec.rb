require 'rspec'
require 'reply' 
require 'question_database' 

describe Reply do 
  
  before(:each) { QuestionDatabase.reset! }
  after(:each) { QuestionDatabase.reset! }
  
end 
