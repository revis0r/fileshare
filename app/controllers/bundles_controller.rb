class BundlesController < ApplicationController
  before_action :set_bundle, only: [:show, :edit, :update, :check]

  # GET /bundles
  # GET /bundles.json
  # def index
  #   @bundles = Bundle.all
  # end

  # GET /bundles/1
  # GET /bundles/1.json
  def show
  end

  # GET /bundles/new
  def new
    @bundle = Bundle.new possible_downloads: 1
    @bundle.slots.new
  end

  # GET /bundles/1/edit
  # def edit
  # end

  # POST /bundles
  # POST /bundles.json
  def create
    @bundle = Bundle.new(bundle_params)

    respond_to do |format|
      if @bundle.save
        session[@bundle.id] = { password: @bundle.password, owner: true }
        format.html { redirect_to @bundle, notice: I18n.t('controllers.bundles.created') }
        format.json { render action: 'show', status: :created, location: @bundle }
      else
        @bundle.slots.new if @bundle.slots.blank?
        format.html { render action: 'new' }
        format.json { render json: @bundle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bundles/1
  # PATCH/PUT /bundles/1.json
  # def update
  #   respond_to do |format|
  #     if @bundle.update(bundle_params)
  #       format.html { redirect_to @bundle, notice: 'Bundle was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: @bundle.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /bundles/1
  # DELETE /bundles/1.json
  def destroy
    @bundle = Bundle.find_by_destroy_code!(params[:id])
    @bundle.destroy
    respond_to do |format|
      format.html { redirect_to bundles_url }
      format.json { head :no_content }
    end
  end

  def check
    respond_to do |format|
      if @bundle.check_password params[:password]
        session[@bundle.id] = { password: params[:password] }
        format.html { redirect_to @bundle, notice: I18n.t('controllers.bundles.decrypted') }
      else
        format.html { redirect_to @bundle, notice: I18n.t('controllers.bundles.incorrect_password') }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bundle
      @bundle = Bundle.find_by_url_id!(params[:id])
      if session[@bundle.id].present?
        @bundle.password = session[@bundle.id][:password]
      elsif params[:password].present? && @bundle.check_password(params[:password])
        session[@bundle.id] = { password: params[:password] }
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bundle_params
      params.require(:bundle).permit(:possible_downloads, :text, :password, slots_attributes: [:file])
    end
end
