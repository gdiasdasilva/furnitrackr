# frozen_string_literal: true

class TrackersController < ApplicationController
  before_action :require_login
  before_action :set_tracker, only: %i[show destroy sync]

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
    @tracker.threshold_price = (tracker_params[:threshold_price].to_f * 100).to_i

    product = ProductFromUrlService.new(url: tracker_params[:url]).call

    if product.present?
      @tracker.product = product
    end

    if @tracker.fetch_current_price.present? && @tracker.save
      redirect_to @tracker, flash: { success: "Tracker was successfully created." }
    else
      render :new
    end
  end

  def destroy
    @tracker.destroy
    redirect_to trackers_url, notice: "Tracker was successfully destroyed."
  end

  def sync
    if @tracker.fetch_current_price.present?
      redirect_to @tracker, flash: { success: "Tracker was successfully synced." }
    else
      redirect_to @tracker, flash: { error: "Error while syncing tracker. Please try again later." }
    end
  end

  private

  def set_tracker
    @tracker = Tracker.where(user: current_user).find(params[:id])
  end

  def tracker_params
    params.require(:tracker).permit(:title, :url, :threshold_price)
  end
end
