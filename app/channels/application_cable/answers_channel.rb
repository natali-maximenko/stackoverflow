class AnswersChannel < ApplicationCable::Channel
  def follow
    stream_from "answers_question_#{data['question_id']}"
  end
end