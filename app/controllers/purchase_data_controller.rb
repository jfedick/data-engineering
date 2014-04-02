class PurchaseDataController < ApplicationController
  before_action :set_purchase_datum, only: [:show, :edit, :update, :destroy]

  # GET /purchase_data
  # GET /purchase_data.json
  def index
    @purchase_data = PurchaseDatum.all
  end

  # GET /purchase_data/1
  # GET /purchase_data/1.json
  def show
  end

  # GET /purchase_data/new
  def new
    @purchase_datum = PurchaseDatum.new
  end

  # GET /purchase_data/1/edit
  def edit
  end

  # POST /purchase_data
  # POST /purchase_data.json
  def create
    @purchase_datum = PurchaseDatum.new(purchase_datum_params)
    respond_to do |format|
      if @purchase_datum.save
        if @purchase_datum.process_file!
          format.html { redirect_to @purchase_datum, notice: 'Purchase datum was successfully created and the data was successfully added to the database.' }
        else
          format.html { redirect_to @purchase_datum, notice: 'Purchase datum was successfully created, but it was not successfully added into the database.' }
        end
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /purchase_data/1
  # PATCH/PUT /purchase_data/1.json
  def update
    respond_to do |format|
      if @purchase_datum.update(purchase_datum_params)
        format.html { redirect_to @purchase_datum, notice: 'Purchase datum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @purchase_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchase_data/1
  # DELETE /purchase_data/1.json
  def destroy
    @purchase_datum.destroy
    respond_to do |format|
      format.html { redirect_to purchase_data_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase_datum
      @purchase_datum = PurchaseDatum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def purchase_datum_params
      params.require(:purchase_datum).permit(:file)
    end
end
