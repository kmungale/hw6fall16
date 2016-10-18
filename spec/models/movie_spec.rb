
describe Movie do
  describe 'searching Tmdb by keyword' do
    context 'with valid key' do
      it 'should call Tmdb with title keywords' do
        expect( Tmdb::Movie).to receive(:find).with('Inception')
        Movie.find_in_tmdb('Inception')
      end
      it 'should raise Tmdb api exception' do
				allow(Tmdb::Movie).to receive(:find).and_raise(NoMethodError)
				expect {Movie.find_in_tmdb('Inception')}.to raise_error(NoMethodError)	
			end
    end
    context 'with invalid key' do
      it 'should raise InvalidKeyError if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:find).and_raise(NoMethodError)
        allow(Tmdb::Api).to	receive(:response).and_return({'code'	=>	'401'})
        expect {Movie.find_in_tmdb('Inception') }.to raise_error(Movie::InvalidKeyError)
      end
    end
    it 'should create new movie in rotten potatoes database' do
      	  fake_results = {"title" => "movie fake", "release_date" => "1997-03-10"}
		  expect(Tmdb::Movie).to receive(:detail).with("12345").
		  and_return(fake_results)
		  Movie.create_from_tmdb("12345")
		end
  end
end
