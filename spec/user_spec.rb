require 'rspec'
require_relative '../user' 
require_relative '../questions_database' 

describe User do

  before(:each) { QuestionsDatabase.reset! }
  after(:each) { QuestionsDatabase.reset! }
  
  
end
