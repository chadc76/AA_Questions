require 'rspec'
require_relative '../reply' 
require_relative '../questions_database' 

describe Reply do 
  
  before(:each) { QuestionsDatabase.reset! }
  after(:each) { QuestionsDatabase.reset! }
  
end 
