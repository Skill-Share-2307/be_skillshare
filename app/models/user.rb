class User < ApplicationRecord
  validates :first_name, :last_name, :lat, :lon, presence: true
  validates :street, :city, :state, :zipcode, presence: true
  validates :is_remote, inclusion: { in: [true, false] }
  validates :email, presence: true, uniqueness: true
  has_many :user_meetings
  has_many :meetings, through: :user_meetings
  has_many :skills

  before_validation :get_coords

  def self.search_for_skills(query)
    User
    .joins(:skills)
    .where("skills.name ILIKE ?", "%#{query}%")
  end

  private

    def get_coords
      if (!self.lat || !self.lon) && self.street
        address = "#{self.street}, #{self.city}, #{self.state} #{self.zipcode}"
        geocode = GeocodingService.new.geocode_address(address)
        self.lat = geocode[:results].first[:lat]
        self.lon = geocode[:results].first[:lon]
      end
    end
end
