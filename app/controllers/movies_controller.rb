class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.pluck(:rating).uniq # Go through all the different types of ratings in the database, make each type unique

    @selected_ratings = params[:ratings] if params.has_key? 'ratings' # Get ratings of checked boxes and store in @selected_ratings
    @ordered_by = params[:order_by] if params.has_key? 'order_by' # order by param created by helper (has a key of either rating or movie title)

    session[:selected_ratings] = @selected_ratings if @selected_ratings # Creating session hash for filter
    session[:ordered_by] = @ordered_by if @ordered_by # Creating session hash for ordering

    if !@selected_ratings && !@ordered_by && session[:selected_ratings]
      @selected_ratings = session[:selected_ratings]
      @ordered_by =  session[:ordered_by]

      redirect_to movies_path({:order_by => @ordered_by, :ratings => @selected_ratings})
    end


    if params.has_key? 'ratings' # if the ratings key is present
      if @ordered_by  # if the user is requesting for table to be ordered
        @movies = Movie.find_all_by_rating(@selected_ratings, :order => "#{@ordered_by} asc") # make it so that the movies can still be ordered even if filtered
      else # if the user is not requesting an ordering...
        @movies = Movie.find_all_by_rating(@selected_ratings)
      end
    elsif @ordered_by # if the ratings key (filter by rating) is not present
      @movies = Movie.all(:order => "#{@ordered_by} asc") # just sort everything by ascending
    else
      @movies = Movie.all # else, just display all movies
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
  # referenced: https://github.com/orendon/saas-rottenpotatoes/
end
