class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :find, only: [:destroy]
  before_action :check_user, only: [:destroy]

  def destroy
    @link.destroy
    path = @link.linkable.is_a?(Question) ? @link.linkable : @link.linkable.question
    redirect_to path, notice: 'Your link succesfully destroyed.'
  end

  private

  def check_user
    unless current_user.author_of?(@link.linkable)
      redirect_to root_path, notice: 'Access denied'
    end
  end

  def find
    @link = Link.find(params[:id])
  end
end
