class Sequel < ActiveRecord::Base

  belongs_to :director
  has_and_belongs_to_many :genres

  class << self
    # Three ways of doing this, I've commented out
    # the more verbose ways just to show you what
    # ActiveRecord can do
    def total_by(director)

      # Selecting custom fields, using select and column aliasing
      # This adds the field (in this case count) to the models returned
      # The column is a string so we convert it into an integer
      #
      # select('COUNT(*) AS count').joins(:director).where("directors.name" => director).first.count.to_i

      # Using find by sql to do the whole query in SQL, this is best when doing something too complex
      # for the active record helpers
      # but it is pretty ugly and unwieldy
      #
     find_by_sql(["SELECT COUNT(*) FROM sequels INNER JOIN directors ON directors.id = sequels.director_id WHERE directors.name = ?", director]).first.count.to_i

      # The neatest way of doing it, but remember this won't work for more complex queries
      # joins(:director).where("directors.name" => director).count
    end

    def total_gross
      find_by_sql("SELECT SUM(gross_earnings) FROM sequels").first.sum.to_i
      # sum('gross_earnings')
    end

    def total_by_genre(genre)
      find_by_sql(["select count(sequels.*) from sequels inner join genres_sequels on genres_sequels.sequel_id = sequels.id inner join genres on genres.id = genres_sequels.genre_id where genres.name = ? ", genre]).first.count.to_i
      # joins(:genres).where("genres.name" => genre).count
    end

    def average_gross_for(director)
      find_by_sql(["select avg(gross_earnings) from sequels inner join directors on directors.id = sequels.director_id where directors.name = ?", director]).first.avg.to_i
      # average(:gross_earnings, :joins => :director, :conditions => ["directors.name = ?", director]).to_i
    end

    def minimum_made_by(director)
      find_by_sql(["select min(gross_earnings) from sequels inner join directors on directors.id = sequels.director_id where directors.name = ?", director]).first.min.to_i
      # minimum(:gross_earnings, :joins => :director, :conditions => ["directors.name = ?",  director] )
    end

    def maximum_gross_before(year)
      find_by_sql(["select max(gross_earnings) from sequels where year < ?", year]).first.max.to_i
      # maximum(:gross_earnings, :conditions => ["year < ?", year])
    end

    def highest_grossing_by_genre_and_director(genre, director)
      find_by_sql(["select max(gross_earnings) as highest_grossing from sequels inner join directors on directors.id = director_id inner join genres_sequels on sequels.id = sequel_id inner join genres on genres.id = genre_id where directors.name = ? and genres.name = ?", director, genre]).first.highest_grossing.to_i
      # here different gvenres not making a difference?
      # joins(:director, :genres).where(["directors.name = ? and genres.name = ?", director, genre]).maximum(:gross_earnings)
    end
  end
end
