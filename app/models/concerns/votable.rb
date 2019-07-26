module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def like
    negative = votes.find_by(value: -1, user: user)
    positive = votes.find_by(value: 1, user: user)
    negative.update!(value: 1) if negative.present?
    votes.create!(value: 1, user: user) if positive.blank? && negative.blank?
  end

  def dislike
    positive = votes.find_by(value: 1, user: user)
    negative = votes.find_by(value: -1, user: user)
    positive.update!(value: -1) if positive.present?
    votes.create!(value: -1, user: user) if positive.blank? && negative.blank?
  end

  def rating
    votes.sum(:value)
  end
end
