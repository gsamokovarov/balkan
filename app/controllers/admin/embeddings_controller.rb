class Admin::EmbeddingsController < Admin::ApplicationController
  def index
    @embeddings = Embedding.where event:
  end

  def show
    @embedding = Embedding.find params[:id]
  end

  def new
    @embedding = Embedding.new event:
  end

  def create
    @embedding = Embedding.new(**embedding_params, event:)

    if @embedding.save
      redirect_to admin_event_embeddings_path(event), notice: "Embedding created"
    else
      render :new
    end
  end

  def edit
    @embedding = Embedding.find params[:id]
  end

  def update
    @embedding = Embedding.find params[:id]

    if @embedding.update embedding_params
      redirect_to admin_event_embeddings_path(event), notice: "Embedding updated"
    else
      render :edit
    end
  end

  private

  def embedding_params = params.require(:embedding).permit(:event_id, :name, :description, :url)
  def event = Event.find(params[:event_id])
end
