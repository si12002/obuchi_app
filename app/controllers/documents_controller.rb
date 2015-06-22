class DocumentsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def index
    @documents = Document.all
  end

  def show
    @document = Document.find(params[:id])
  end

  def create
  	@document = current_user.documents.build(document_params)
    if @document.save
      flash[:success] = "Document created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @document.destroy
    redirect_to root_url
  end

  private
    def document_params
      params.require(:document).permit(:content, :lat, :lng, :date, :weather)
    end

    def correct_user
      @document = current_user.documents.find_by(id: params[:id])
      redirect_to root_url if @document.nil?
    end
end
