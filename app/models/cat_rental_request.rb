class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates_inclusion_of :status, in: %w( PENDING APPROVED DENIED )
  validate :good_date_range
  validate :no_overlapping_requests

  belongs_to(
  :cat,
  :class_name => "Cat",
  :foreign_key => :cat_id,
  :primary_key => :id
  )

  def good_date_range
    unless self.start_date < self.end_date
      errors.add(:start_date, "Start date can't be after end date!")
    end
  end

  def overlapping_requests
    our_cat_requests = CatRentalRequest.select("cat_rental_requests.id")
      .joins("JOIN cats ON cat_id = cats.id")
      .where("cat_id = ?", self.cat_id)

    overlapping_approved = CatRentalRequest.select("cat_rental_requests.id")
      .where(
      "(cat_rental_requests.end_date >= #{self.start_date} OR
      cat_rental_requests.start_date <= #{self.end_date}) AND
      cat_rental_requests.status = 'APPROVED'"
      )

      our_cat_requests.each do |request|
        p request
        return false if overlapping_approved.include?(request)
      end

      return true
      # our_cat_requests.select("cat_rental_request.id")
      #   .where("cat_rental_request.id IN #{overlapping_approved}")





    # mysql = (<<-SQL)
   #    SELECT
   #      cat_rental_requests.id
   #    FROM
   #      cat_rental_requests
   #    JOIN
   #      cats ON cat_id = cats.id
   #    WHERE
   #      cat_id = #{:cat_id} AND cat_rental_requests.id IN (
   #      SELECT
   #        cat_rental_requests.id
   #      FROM
   #        cat_rental_requests
   #      WHERE
   #        (cat_rental_requests.end_date >= #{:start_date} OR
   #        cat_rental_requests.start_date =< #{:end_date}) AND
   #        cat_rental_requests.status = "APPROVED" AND
   #        cat_rental_requests.id != #{:id}
   #      )
   #  SQL


  end

  def no_overlapping_requests
    unless self.overlapping_requests
      errors.add(:start_date, "Your request overlaps with an approved request!")
    end
  end
end