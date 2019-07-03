class RemoveAnswerRefFromQuestion < ActiveRecord::Migration[5.2]
  def change
    remove_reference :questions, :answer 
  end
end
