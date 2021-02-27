require 'rspec'
require_relative '../question' 
require_relative '../questions_database' 

describe Question do 
  before(:each) { QuestionsDatabase.reset! }
  after(:each) { QuestionsDatabase.reset! }
  
end
