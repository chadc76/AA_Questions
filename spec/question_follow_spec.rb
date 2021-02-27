require 'rspec'
require_relative '../question_follow'
require_relative '../questions_database.rb'

describe QuestionFollow do 
  
  before(:each) { QuestionsDatabase.reset! }
  after(:each) { QuestionsDatabase.reset! }
  
end 
