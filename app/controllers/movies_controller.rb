class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    @detected_ratings = ['']
    if session[:sort] != params[:sort] and !params[:sort].nil?
      session[:sort] = params[:sort]
    end
    if session[:ratings] != params[:ratings] and !params[:ratings].nil? 
      session[:ratings] = params[:ratings]
    end
    if params[:sort].nil? and params[:ratings].nil? and (!session[:sort].nil? or !session[:ratings].nil?)
      redirect_to(movies_path(:sort => session[:sort], :ratings => session[:ratings]))
    end
    @sorted_by = session[:sort]
    @detected_ratings = session[:ratings]
    
    if @sorted_by.nil?
      @movies = Movie.all
    else 
      @movies = Movie.order(@sorted_by)
    end

    if @detected_ratings.nil?
      @detected_ratings = @all_ratings
    else
      @detected_ratings = @detected_ratings.keys
    end

    if @sorted_by.nil?
      @movies = Movie.find_all_by_rating(@detected_ratings)
    else
      @movies = Movie.order(@sorted_by).find_all_by_rating(@detected_ratings)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
