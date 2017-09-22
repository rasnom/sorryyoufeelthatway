class CardTemplatesController < ApplicationController

  def index
    @templates = CardTemplate.all
  end

  def show

  end

end
