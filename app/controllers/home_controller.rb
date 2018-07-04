class HomeController < ApplicationController
  def index
  end

  def calculate
    render :index if params[:input].nil?
    @result = Calculation.new.evaluate_arithmetic_expression params[:input]
    render :index
  end
end
