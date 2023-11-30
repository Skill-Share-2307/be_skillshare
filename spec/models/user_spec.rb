require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do 
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    xit {}
  end 

  describe 'relationships' do 
    it { should have_many(:user_meetings) }
    it { should have_many(:meetings).through(:user_meetings) }
  end
end
