class UserSerializer
include JSONAPI::Serializer

  attributes :first_name, :last_name, :email, :address, :about, :lat, :lon, :is_remote, :skills

  attribute :skills do |user|
    user.skills.map do |skill|
      {
        name: skill.name,
        proficiency: skill.proficiency
      }
    end
  end

  attribute :address do |user|
    {
      street: user.street,
      city: user.city,
      state: user.state,
      zipcode: user.zipcode
    }
  end
end