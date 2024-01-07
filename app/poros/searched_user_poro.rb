class SearchedUserPoro
  attr_reader :id,
              :first_name,
              :last_name,
              :is_remote,
              :skills,
              :distance

  def initialize(searched_user, current_user)
    @id = searched_user.id
    @first_name = searched_user.first_name
    @last_name = searched_user.last_name
    @is_remote = searched_user.is_remote
    @skills = build_skills(searched_user)
    @distance = get_distance(searched_user, current_user)
  end

  private

  def build_skills(user)
    user.skills.map do |skill|
      {
        name: skill.name,
        proficiency: skill.proficiency
      }
    end
  end

  # Haversine calculation for distance between two decimal coordinate pairs
  def get_distance(searched_user, current_user)
    return nil if (!searched_user[:lat] || !searched_user[:lon]) || (!current_user[:lat] || !current_user[:lon])
    r = 6371000
    phi_1 = to_radian(searched_user[:lat])
    phi_2 = to_radian(current_user[:lat])
    d_phi = to_radian(current_user[:lat] - searched_user[:lat])
    d_lam = to_radian(current_user[:lon] - searched_user[:lon])

    a = Math.sin(d_phi / 2.0)**2 + Math.cos(phi_1) * Math.cos(phi_2) * Math.sin(d_lam / 2.0)**2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    miles = (r * c * 0.000621).round
    miles >= 1 ? miles : 1 # Ensure we never send 0 as a distance
  end

  def to_radian(degree)
    degree / 180.0 * Math::PI
  end
end
