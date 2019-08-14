class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "comments_question_#{data['question_id']}"
  end
end