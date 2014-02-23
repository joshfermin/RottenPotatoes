module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end

  def was_checked?(rating)
    if @selected_ratings != nil
      @selected_ratings.include? rating unless !@selected_ratings
    else
      @all_ratings
    end
  end

  def create_order_params(column)
    {:order_by => column, :ratings => @selected_ratings}  # set current ratings as @selected ratings, change order_by to column
  end

end
