module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find, only: [:like, :dislike]
  end

  def like
    @resource.like unless current_user.author_of?(@resource)

    render json: { id: @resource.id, rating: @resource.rating }
  end

  def dislike
    @resource.dislike unless current_user.author_of?(@resource)

    render json: { id: @resource.id, rating: @resource.rating }
  end

  private

  def find
    @resource = controller_name.classify.constantize.find(params[:id])
  end
end
