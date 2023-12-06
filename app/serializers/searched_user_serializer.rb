class SearchedUserSerializer
include JSONAPI::Serializer
  attributes :first_name, :last_name, :is_remote, :skills, :distance
end