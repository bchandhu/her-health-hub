class LogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_log, only: %i[show edit update destroy]

  # GET /logs
  def index
    @logs = current_user.calendar_entries
  end

  # GET /logs/1
  def show
  end

  # GET /logs/new
  def new
    @log = current_user.calendar_entries.build
    @log.date = params[:date] if params[:date].present?
  end
  

  # GET /logs/1/edit
  def edit
  end

  # POST /logs
  def create
    @log = current_user.calendar_entries.build(log_params)

    respond_to do |format|
      if @log.save
        format.html { redirect_to @log, notice: "Log was successfully created." }
        format.json { render :show, status: :created, location: @log }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /logs/1
  def update
    respond_to do |format|
      if @log.update(log_params)
        format.html { redirect_to @log, notice: "Log was successfully updated." }
        format.json { render :show, status: :ok, location: @log }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /logs/1
  def destroy
    @log.destroy
    respond_to do |format|
      format.html { redirect_to logs_url, notice: "Log was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_log
      @log = current_user.calendar_entries.find(params[:id])
    end

    def log_params
      params.require(:log).permit(:date, :note)
    end
end
