require 'rspec'
require 'question_follow'
require 'question_database.rb'

describe QuestionFollow do 
  
  before(:each) { QuestionDatabase.reset! }
  after(:each) { QuestionDatabase.reset! }
  
end 
