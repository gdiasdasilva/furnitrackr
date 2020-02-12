# frozen_string_literal: true

class TrackersController < ApplicationController
  before_action :require_login
  before_action :set_tracker, only: %i[show destroy]

  def index
    @trackers = Tracker.where(user: current_user)
  end

  def show; end

  def new
    @tracker = Tracker.new
  end

  def create
    @tracker = Tracker.new(tracker_params)
    @tracker.user = current_user
    @tracker.product = product_from_url(url)

    if @tracker.save
      redirect_to @tracker, flash: { success: 'Tracker was successfully created.' }
    else
      render :new
    end
  end

  def destroy
    @tracker.destroy
    redirect_to trackers_url, notice: 'Tracker was successfully destroyed.'
  end

  private

  def set_tracker
    @tracker = Tracker.find(params[:id])
  end

  def tracker_params
    params.require(:tracker).permit(:title, :url, :threshold_price, :enabled)
  end

  def product_from_url(url)
    url_path = URI(url).path
    url_path.split('/').last

    Product.find_or_create_by(
      provider_identifier: product_identifier,
      provider: Product::PROVIDERS.fetch(:ikea),
    )
  end
end
