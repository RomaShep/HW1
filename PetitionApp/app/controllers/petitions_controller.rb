class PetitionsController < ApplicationController
  LIST_NUM = 10
  @x_petition = true

  def index
    @x_petition = false
    @petitions = Petition.all.last(LIST_NUM)
  end

  def show
    @petition = Petition.find(params[:id])
  end

  def all
    @x_petition =true
    @petitions = Petition.all
  end


  def new
    if current_user
      @petition = Petition.new
    else
      redirect_to log_in_path
    end
  end


  def create

    #@user = User.find(params[:user_id])
    @petition = current_user.petitions.create(petition_params)


    #@petition = Petition.new(petition_params)
    if @petition.save
       redirect_to @petition
    else
      render "new"   
    end
   end

  private
  def petition_params
    params.require(:petition).permit(:name, :description)
  end

end
