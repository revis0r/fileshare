class SlotsController < ApplicationController
  def download
    @bundle = Bundle.find_by_url_id!(params[:bundle_id])
    @slot = @bundle.slots.find(params[:id])
    if session[@bundle.id].present? && session[@bundle.id][:password].present?
      @tmp_file = @slot.decrypt session[@bundle.id][:password]
      logger.warn @tmp_file
      File.open(@tmp_file, 'r') do |f|
        send_data f.read, :filename => @slot[:file]
      end
      @slot.downloaded
    else
      redirect_to @bundle, notice: I18n.t('controllers.slots.access_denied')
    end
  ensure
    File.unlink @tmp_file if @tmp_file.present?
  end
end
