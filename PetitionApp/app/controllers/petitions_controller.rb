class PetitionsController < ApplicationController
  LIST_NUM = 10

  def index
    if params[:all]
      @petitions = Petition.all
    else
      @petitions = Petition.order(created_at: :desc).limit(LIST_NUM)
    end
    @petitions = @petitions.where(user: current_user) if params[:my]
  end

  def show
    @petition = Petition.find(params[:id])
  end

  def vote
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

  def edit
    @petition = Petition.find(params[:id])
  end

  def create
    @petition = current_user.petitions.create(petition_params)
    if @petition.save
       redirect_to @petition, :notice => "Петиция создана!"
    else
      render "new"   
    end
   end

  def update
    @petition = Petition.find(params[:id])
   
    if @petition.update(petition_params)
      redirect_to @petition , :notice => "Петиция обновлена!"
    else
      render 'edit'
    end
  end

  def destroy
    @petition = Petition.find(params[:id])
    @petition.destroy
   
    redirect_to @petition, :notice => "Петиция удалена!"
  end

  private
  def petition_params
    params.require(:petition).permit(:name, :description)
  end

end
