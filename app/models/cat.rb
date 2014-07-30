class Cat < ActiveRecord::Base
  validates :name, :birth_date, :color, :sex, :description, :age, presence: true
  validates :age, numericality: true
  validates_inclusion_of :sex, in: %w( M F )
  
  has_many(
    :requests,
    :class_name => "CatRentalRequest",
    :foreign_key => :cat_id,
    :primary_key => :id
  )
end