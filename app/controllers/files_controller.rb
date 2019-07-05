class FilesController < ApplicationController
  before_action :authenticate_user!, only: [:destroy]
  before_action :find_file, only: [:destroy]
  before_action :check_user, only: [:destroy]

  def destroy
    @file.purge
    redirect_to @file.record, notice: 'Your file succesfully destroyed.'
  end

  private

  def find_file
    @file = ActiveStorage::Attachment.find(params[:id])
  end

  def check_user
    unless current_user.author_of?(@file.record)
      redirect_to root_path, notice: 'Access denied'
    end
  end
end