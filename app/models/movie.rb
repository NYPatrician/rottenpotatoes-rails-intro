class Movie < ActiveRecord::Base
    def Movie.all_ratings
        return Movie.select(:rating).distinct.pluck(:rating)
    end
end
