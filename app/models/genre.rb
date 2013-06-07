class Genre < ActiveRecord::Base
  has_and_belongs_to_many :sequels


  def self.with_more_than_one_film
    find_by_sql("select genres.name from genres inner join genres_sequels on genres.id = genre_id inner join sequels on sequels.id = sequel_id group by genres.name HAVING count(sequel_id) > 1").map {|genre| genre.name }
  end
end