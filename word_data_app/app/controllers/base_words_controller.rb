class BaseWordsController < ApplicationController
  before_action :set_base_word, only: [:show, :edit, :update, :destroy]

  # GET /base_words
  # GET /base_words.json
  def index
    @base_words = BaseWord.all
  end

  # GET /base_words/1
  # GET /base_words/1.json
  def show
    respond_to do |format|
      format.html
      format.json { render json: @base_word}
    end
  end

  # GET /base_words/new
  def new
    @base_word = BaseWord.new
  end

  # GET /base_words/1/edit
  def edit
  end

  # POST /base_words
  # POST /base_words.json
  def create
    @base_word = BaseWord.new(base_word_params)

    respond_to do |format|
      if @base_word.save
        format.html { redirect_to @base_word, notice: 'Base word was successfully created.' }
        format.json { render :show, status: :created, location: @base_word }
      else
        format.html { render :new }
        format.json { render json: @base_word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /base_words/1
  # PATCH/PUT /base_words/1.json
  def update
    respond_to do |format|
      if @base_word.update(base_word_params)
        format.html { redirect_to @base_word, notice: 'Base word was successfully updated.' }
        format.json { render :show, status: :ok, location: @base_word }
      else
        format.html { render :edit }
        format.json { render json: @base_word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /base_words/1
  # DELETE /base_words/1.json
  def destroy
    @base_word.destroy
    respond_to do |format|
      format.html { redirect_to base_words_url, notice: 'Base word was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_base_word
      @base_word = BaseWord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def base_word_params
      params.require(:base_word).permit(:base_word, :pos_id, :frequency, :language_id)
    end
end
