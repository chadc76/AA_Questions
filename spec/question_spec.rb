require 'rspec'
require 'question' 
require 'question_database' 

describe Question do 
  before(:each) { QuestionDatabase.reset! }
  after(:each) { QuestionDatabase.reset! }
  
end
