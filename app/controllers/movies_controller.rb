class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    session[:sort] = params[:sort] if params[:sort]
    session[:ratings] = params[:ratings] if params[:ratings] 
    
    @all_ratings = Movie.all_ratings
    
    if params[:ratings] and (params[:sort] or session[:sort] == nil) then
      @title_header = "hilite" if params[:sort] == "title"
      @release_date_header = "hilite" if params[:sort] == "release_date"
      @rating_filter = params[:ratings].keys 
      @movies = Movie.where(rating: @rating_filter).order(params[:sort])
    else 
      if session[:ratings] == nil then
        session[:ratings] = Hash.new
        @all_ratings.each {|rating| (session[:ratings])[rating] = 1}
      end
      flash.keep
      redirect_to :sort => session[:sort], :ratings => session[:ratings]
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
