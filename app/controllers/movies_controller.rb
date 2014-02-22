class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.pluck(:rating).uniq

    @selected_ratings = params[:ratings] if params.has_key? 'ratings' # Get ratings of checked boxes and store in @selected_ratings
    @ordered_by = params[:order_by] if params.has_key? 'order_by'

    if params.has_key? 'ratings'
      if @ordered_by
        @movies = Movie.find_all_by_rating(@selected_ratings, :order => "#{@ordered_by} asc") # make it so that the movies can still be ordered even if filtered
      else
        @movies = Movie.find_all_by_rating(@selected_ratings)
      end
    elsif @ordered_by
      @movies = Movie.all(:order => "#{@ordered_by} asc")
    else
      @movies = Movie.all
  end

    #if params.has_key? 'ratings'
    #  @movies = Movie.find_all_by_rating(params[:ratings])
    #else
    #  @movies = Movie.order(params[:sort_param]) # orders the movies by the current parameter
    #end
    #
    #@sort = params[:sort_param] # This checks if it is ordered by movie title or Ratings to change the css to hilight the title
    #@all_ratings = Movie.pluck(:rating).uniq # Go through all the different types of ratings in the database, make each type unique
    #
    #@selected_ratings = if params[:ratings].present? # if the param ratings is present
    #                      params[:ratings] # assign @selected_ratings to params[:ratings]
    #                    else
    #                      [] # else, set selected ratings to empty array.
    #                    end
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
