require 'rails_helper'

RSpec.describe Meeting, type: :model do
  describe 'relationships' do 
    it { should have_many(:user_meetings) }
    it { should have_many(:users).through(:user_meetings) }
  end
end
