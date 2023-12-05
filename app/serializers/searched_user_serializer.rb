class SearchedUserSerializer
include JSONAPI::Serializer

  attributes :first_name, :last_name, :is_remote, :skills, :distance

  #could potentially have a parent class to inherit from to DRY up code
  attribute :skills do |user|
    user.skills.map do |skill|
      {
        name: skill.name,
        proficiency: skill.proficiency
      }
    end
  end
end