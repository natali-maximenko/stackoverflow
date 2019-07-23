module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def like
    vote = votes.find_by(value: -1, user: user)
    if vote.present?
      vote.update!(value: 1)
    else
      votes.create!(value: 1, user: user)
    end
  end

  def dislike
    vote = votes.find_by(value: 1, user: user)
    if vote.present?
      vote.update!(value: -1)
    else
      votes.create!(value: -1, user: user)
    end
  end

  def rating
    votes.sum(:value)
  end
end