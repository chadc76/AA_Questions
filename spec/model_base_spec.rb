require 'rspec'
require_relative '../model_base'
require_relative '../question_follow'
require_relative '../reply'
require_relative '../question_like'

describe ModelBase do 
  
  before(:each) { QuestionsDatabase.reset! }
  after(:each) { QuestionsDatabase.reset! }
end 
