class Skill < ApplicationRecord
  belongs_to :user
  enum purpose: { educational: "educational", casual: "casual" }
end
