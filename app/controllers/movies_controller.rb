class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    if params.has_key? 'ratings'
      @movies = Movie.find_all_by_rating(params[:ratings])
    else
      @movies = Movie.order(params[:sort_param]) # orders the movies by the current parameter
    end

    @sort = params[:sort_param] # This checks if it is ordered by movie title or Ratings to change the css to hilight the title
    @all_ratings = Movie.pluck(:rating).uniq # Define the instance variable all_ratings and call the class method to get all the ratings.
    
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
