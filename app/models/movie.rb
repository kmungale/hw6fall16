class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  class Movie::InvalidKeyError < StandardError ; end
  
  def self.find_in_tmdb(string)
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    begin
      if string.empty?
        return [].as_json
      end
      movies = Tmdb::Movie.find(string)
      movies.as_json
    rescue NoMethodError => tmdb_gem_exception
      if Tmdb::Api.response['code'] == '401'
        raise Movie::InvalidKeyError, 'Invalid API key'
      else 
        raise tmdb_gem_exception
      end
    end
  end
  
  def self.create_from_tmdb(id)
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    tmdb_movie = Tmdb::Movie.detail(id)
    movie = Movie.new
    movie.title = tmdb_movie["title"]
    movie.rating = "R"
    movie.release_date = tmdb_movie["release_date"]
    movie.save
  end  
  
end
