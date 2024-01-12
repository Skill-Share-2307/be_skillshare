class User < ApplicationRecord
  validates :first_name, :last_name, :lat, :lon, presence: true
  validates :street, :city, :state, :zipcode, presence: true
  validates :is_remote, inclusion: { in: [true, false] }
  validates :email, presence: true, uniqueness: true

  has_many :user_meetings
  has_many :meetings, through: :user_meetings
  has_many :skills

  before_validation :get_coords
  # before_create :set_profile_picture
  after_save :set_profile_picture

  def self.search_for_skills(query)
    skills = query.split(',').map { |skill| skill.strip.downcase }
    
    conditions = skills.map { |skill|
      "LOWER(skills.name) ILIKE '%#{sanitize_sql_like(skill)}%'"
    }.join(' OR ')
  
    User.joins(:skills).where(conditions).distinct
  end

  def self.remote_users
    User.where(is_remote: true)
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

  def set_profile_picture
    image = ImageService.new.user_image
    # image = {error: "a"}
    if self.profile_picture
      return
    elsif !image[:error]
      self.update(profile_picture: image[:data][:attributes][:raw_image])
    else
      self.profile_picture = nil
      RetryImageServiceJob.perform_in(15.seconds, self.id)
    end
  end
end
