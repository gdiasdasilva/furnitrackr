class PagesController < ApplicationController
  layout "homepage", only: [:homepage]

  def homepage; end

  def how_does_it_work; end
end
