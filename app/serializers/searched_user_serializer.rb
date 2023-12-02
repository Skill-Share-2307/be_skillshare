class SearchedUserSerializer
include JSONAPI::Serializer

  attributes :first_name, :last_name, :is_remote, :skills

  attribute :skills do |user|
    user.skills.map do |skill|
      {
        name: skill.name,
        proficiency: skill.proficiency
      }
    end
  end

  #placeholder to render the proximity of the user to the searcher
  #how are we going to get the lat/lon of the searcher? 
  # attribute :proximity
end