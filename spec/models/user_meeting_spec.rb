require 'rails_helper'

RSpec.describe UserMeeting, type: :model do
  describe 'relationships' do 
    it { should belong_to(:user) }
    it { should belong_to(:meeting) }
  end
end
