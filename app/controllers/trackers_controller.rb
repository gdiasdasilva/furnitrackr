# frozen_string_literal: true

class TrackersController < ApplicationController
  before_action :require_login
  before_action :set_tracker, only: %i[show edit update destroy]

  # GET /trackers
  # GET /trackers.json
  def index
    @trackers = Tracker.where(user: current_user)
  end

  # GET /trackers/1
  # GET /trackers/1.json
  def show; end

  # GET /trackers/new
  def new
    @tracker = Tracker.new
  end

  # POST /trackers
  # POST /trackers.json
  def create
    @tracker = Tracker.new(tracker_params)
    @tracker.user = current_user

    product_identifier = set_product(tracker_params[:url])

    if product_identifier.present?
      product = Product.find_or_create_by!(
        provider_identifier: product_identifier,
        provider: Product::PROVIDERS.fetch(:ikea)
      )
      @tracker.product = product
    end

    respond_to do |format|
      if @tracker.save
        format.html {
          redirect_to @tracker,
          flash: { success: 'Tracker was successfully created.' }
        }
        format.json { render :show, status: :created, location: @tracker }
      else
        format.html { render :new }
        format.json { render json: @tracker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trackers/1
  # DELETE /trackers/1.json
  def destroy
    @tracker.destroy
    respond_to do |format|
      format.html { redirect_to trackers_url, notice: 'Tracker was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tracker
    @tracker = Tracker.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tracker_params
    params.require(:tracker).permit(:title, :url, :threshold_price, :enabled)
  end

  def set_product(url)
    url_path = URI(url).path
    url_path.split('/').last
  end
end
