class Movie < ActiveRecord::Base
  # create a class method in the model, which returns an array
  def self.all_ratings
    Array['G','PG','PG-13','R','NC-17']
  end
end
