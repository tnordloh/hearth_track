class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  # GET /games
  # GET /games.json
  def index
    if params[:deck_id] == nil
      @games = Game.all
    else
      @games = Deck.find(params[:deck_id]).games
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @graph = graphme([10])
  end

  # GET /games/new
  def new
    if params[:deck_id] == nil
      redirect_to decks_path, :notice => "select or create a deck first"
      return
    else
      session[:deck_id] = params[:deck_id]
      @deck = Deck.find(params[:deck_id])
      @game = Game.new
    end
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    @deck = Deck.find(session[:deck_id])
    game_params[:deck] = @deck
    @game = @deck.games.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render action: 'show', status: :created, location: @game }
      else
        format.html { render action: 'new' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:deck, :opponent_class, :did_i_win)
    end
end
