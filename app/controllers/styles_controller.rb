class StylesController < ApplicationController
  before_action :set_style, only: [:show]

  def index
    @styles = Style.all
  end

  def show
  end

  def new
  end

  private
  def set_style
    @style = Style.find(params[:id])
  end

end
