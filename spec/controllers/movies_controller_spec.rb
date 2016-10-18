require 'spec_helper'
require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do
   it 'should call the model method that performs TMDb search' do
      fake_results = [double('movie1'), double('movie2')]
      expect(Movie).to receive(:find_in_tmdb).with('Ted').
        and_return(fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
    end
    it 'should select the Search Results template for rendering' do
      allow(Movie).to receive(:find_in_tmdb)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(response).to render_template('search_tmdb')
    end  
    it 'should make the TMDb search results available to that template' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(assigns(:movies)).to eq(fake_results)
    end
    it 'should return message no movie found in TMDb' do
        post :search_tmdb, {:search_terms	=> 'abcdefgh'}
        expect(response).to redirect_to('/movies')
		    expect(flash[:notice]).to eq "No matching movies were found on TMDb"
    end
    it 'should return invalid search term' do
        post :search_tmdb, {:search_terms	=>	'      '}
        expect(response).to redirect_to('/movies')
		    expect(flash[:notice]).to eq "Invalid search term"
    end
    it 'should return Movies were successfully added' do
        post :add_tmdb,	{:checkbox	=>	{"123456" => "1"}}
        expect(response).to redirect_to('/movies')
		    expect(flash[:notice]).to eq "Movies successfully added to Rotten Potatoes"
    end
    it 'should return No movies selected' do
        post :add_tmdb,	{:tmdb_movies	=>	nil}
        expect(response).to redirect_to('/movies')
		    expect(flash[:notice]).to eq "No movies were selected"
	  end
  end
end
