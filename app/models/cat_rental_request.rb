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
    our_cat_requests = CatRentalRequest.joins(
    "JOIN cats ON cat_id = cats.id")
    .where("cat_id = ?", self.cat_id)

    overlapping = CatRentalRequest.where(
      "NOT (cat_rental_requests.start_date >= #{self.end_date} OR cat_rental_requests.end_date <= #{self.start_date})"
      )

      p overlapping

      # AND cat_rental_requests.status = 'APPROVED'

      overlapping_requests = []

      our_cat_requests.each do |request|
        if overlapping.include?(request)
          overlapping_requests << request
        end
      end

      overlapping_requests
  end

  def overlapping_approved
    overlapping_requests.select { |request| request.status == "APPROVED" }
  end

  def approve!
    self.overlapping_requests.each do |request|
      request.deny!
    end

    self.status = "APPROVED"
    self.save!
  end

  def deny!
    self.status = "DENIED"
    self.save!
  end

  def no_overlapping_requests
    unless self.overlapping_approved.empty?
      errors.add(:start_date, "Your request overlaps with an approved request!")
    end
  end
end