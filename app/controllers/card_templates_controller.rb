class CardTemplatesController < ApplicationController

  def index
    @templates = CardTemplate.all
  end

  def show
    @template = CardTemplate.find(params[:id])
  end

end
