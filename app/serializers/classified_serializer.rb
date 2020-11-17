class ClassifiedSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :price, :description
end
