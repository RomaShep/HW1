class VotesController < ApplicationController

  
  def create
    #byebug
    #@vote = current_user.petitions.vote.create(vote_params)

    @vote = Vote.new(vote_params)
    if @vote.save
      redirect_to petitions_path(vote_params[:petition_id]), :notice => "Вы проголосовали!"
    else
      redirect_to petitions_path(vote_params[:petition_id]), :notice => "Вы не можете голосовать дважды!"
    end
  end

private
  def vote_params
    params.permit(:user_id, :petition_id)
  end

end
