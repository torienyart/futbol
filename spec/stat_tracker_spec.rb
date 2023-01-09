require './lib/stat_tracker'
require './lib/data_factory'

describe StatTracker do
  let(:game_path){'./data/fixtures/games_i1.csv'}
  let(:team_path){'./data/teams.csv'}
  let(:game_teams_path){'./data/fixtures/game_teams_i1.csv'}
  
  let(:locations){{
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }}

  # it 'can pull in new data from files' do
  #   expect(StatTracker.from_csv(locations)).to be_an_instance_of(StatTracker)
  # end

  it 'can pull in new data from files' do
    expect(DataFactory.from_csv(locations)).to be_an_instance_of(StatTracker)
  end

  describe 'game' do  
    it 'can pull in games csv data' do
      expect(StatTracker.games_csv(locations).length).to eq(19)
      expect(StatTracker.games_csv(locations)[0].game_id).to eq('2012030221')
      expect(StatTracker.games_csv(locations)[0].season).to eq('20122013')
      expect(StatTracker.games_csv(locations)[0].type).to eq('Postseason')
      expect(StatTracker.games_csv(locations)[0].date_time).to eq('5/16/13')
      expect(StatTracker.games_csv(locations)[0].away_team_id).to eq('3')
      expect(StatTracker.games_csv(locations)[0].home_team_id).to eq('6')
      expect(StatTracker.games_csv(locations)[0].away_goals).to eq('2')
      expect(StatTracker.games_csv(locations)[0].home_goals).to eq('3')
      expect(StatTracker.games_csv(locations)[0].venue).to eq('Toyota Stadium')
      expect(StatTracker.games_csv(locations)[0].venue_link).to eq('/api/v1/venues/null')
    end
  end

  describe 'team' do
    it 'can pull in teams csv data' do
      expect(StatTracker.teams_csv(locations).length).to eq(32)
      expect(StatTracker.teams_csv(locations)[0].team_id).to eq('1')
      expect(StatTracker.teams_csv(locations)[0].franchise_id).to eq('23')
      expect(StatTracker.teams_csv(locations)[0].team_name).to eq('Atlanta United')
      expect(StatTracker.teams_csv(locations)[0].abbreviation).to eq('ATL')
      expect(StatTracker.teams_csv(locations)[0].stadium).to eq('Mercedes-Benz Stadium')
      expect(StatTracker.teams_csv(locations)[0].link).to eq('/api/v1/teams/1')
    end
  end

  describe 'game_team' do
    it 'can pull in game_teams csv data' do
      expect(StatTracker.game_teams_csv(locations).length).to eq(19) 
      expect(StatTracker.game_teams_csv(locations)[0].game_id).to eq('2012030221')
      expect(StatTracker.game_teams_csv(locations)[0].team_id).to eq('3')
      expect(StatTracker.game_teams_csv(locations)[0].hoa).to eq('away')
      expect(StatTracker.game_teams_csv(locations)[0].result).to eq('LOSS')
      expect(StatTracker.game_teams_csv(locations)[0].settled_in).to eq('OT')
      expect(StatTracker.game_teams_csv(locations)[0].head_coach).to eq('John Tortorella')
      expect(StatTracker.game_teams_csv(locations)[0].goals).to eq('2')
      expect(StatTracker.game_teams_csv(locations)[0].shots).to eq('8')
      expect(StatTracker.game_teams_csv(locations)[0].tackles).to eq('44')
      expect(StatTracker.game_teams_csv(locations)[0].pim).to eq('8')
      expect(StatTracker.game_teams_csv(locations)[0].power_play_opportunities).to eq('3')
      expect(StatTracker.game_teams_csv(locations)[0].power_play_goals).to eq('0')
      expect(StatTracker.game_teams_csv(locations)[0].face_off_win_percentage).to eq('44.8')
      expect(StatTracker.game_teams_csv(locations)[0].giveaways).to eq('17')
      expect(StatTracker.game_teams_csv(locations)[0].takeaways).to eq('7')
    end
  end

  describe 'game statistics' do
    let(:game_path_2){'./data/fixtures/games_i2.csv'}
    #note that we will need to edit team/game_team paths if new fixture data is created for use in these tests
    
    let(:locations_2){{
      games: game_path_2,
      teams: team_path,
      game_teams: game_teams_path
    }}

    let(:stat_tracker) {StatTracker.from_csv(locations_2)}

    it "can determine #average_goals_per_game" do
      expect(stat_tracker.average_goals_per_game).to eq(4.45)
    end

    it 'can determine #count_of_games_by_season' do
      expected = {
        "20122013"=>7,
        "20132014"=>10,
        "20142015"=>2,
        "20152016"=>9,
        "20162017"=>9,
        "20172018"=>12
      }
      expect(stat_tracker.count_of_games_by_season).to eq expected
    end

    it "can determine #average_goals_by_season" do
      expected = {
        "20122013"=>5,
        "20132014"=>4.8,
        "20142015"=>4.5,
        "20152016"=>3.78,
        "20162017"=>4.44,
        "20172018"=>4.33
      }
      expect(stat_tracker.average_goals_by_season).to eq(expected)
    end

    it "can determine #home_wins" do
      expect(stat_tracker.home_wins).to eq(20)
    end

    it "can determine #away_wins" do
      expect(stat_tracker.away_wins).to eq(23)
    end

    it "can determine #tie_games" do
      expect(stat_tracker.tie_games).to eq(6)
    end

    it "can determine #percentage_home_wins" do
      expect(stat_tracker.percentage_home_wins).to eq(0.41)
    end

    it "can determine #percentage_visitor_wins" do
      expect(stat_tracker.percentage_visitor_wins).to eq(0.47)
    end

    it "can determine #percentage_ties" do
      expect(stat_tracker.percentage_ties).to eq(0.12)
    end

    it "can determine highest_total_score" do
      expect(stat_tracker.highest_total_score).to eq(8)
    end

    it "can determine lowest_total_score" do
      expect(stat_tracker.lowest_total_score).to eq(1)
    end
  end

  describe 'league statistics' do
    let(:game_path_2){'./data/fixtures/games_i2.csv'}
    #note that we will need to edit team/game_team paths if new fixture data is created for use in these tests
    
    let(:locations_2){{
      games: game_path_2,
      teams: team_path,
      game_teams: game_teams_path
    }}

    let(:stat_tracker) {StatTracker.from_csv(locations_2)}

    it 'can count the number of teams' do
      expect(stat_tracker.count_of_teams).to eq(32)
    end
    
    it 'can calculate the lowest_scoring_home' do
      expect(stat_tracker.lowest_scoring_home_team).to eq("Sporting Kansas City")
    end

    it 'can calculate the highest_scoring_home' do
      expect(stat_tracker.highest_scoring_home_team).to eq("Los Angeles FC, New England Revolution, Real Salt Lake")
    end

    it 'can calculate the lowest_scoring_visitor' do
      expect(stat_tracker.lowest_scoring_visitor).to eq("FC Cincinnati, Sporting Kansas City, New York Red Bulls")
    end

    xit 'can calculate #team_score_averages array length' do
      expect(stat_tracker.team_score_averages.length).to eq(31)
    end

    #Refactor
    it 'can calculate #team_score_averages array length' do
    expected_array = [["5", 0.5], ["8", 1.3333], ["53", 1.5], ["26", 1.6], ["22", 1.6667],
    ["18", 1.75], ["21", 1.75], ["10", 2.0], ["2", 2.0], ["30", 2.0], ["17", 2.0], ["28", 2.0],
    ["27", 2.0], ["1", 2.0], ["20", 2.0], ["15", 2.2], ["52", 2.2], ["6", 2.25], ["13", 2.3333],
    ["12", 2.3333], ["3", 2.5], ["9", 2.5], ["25", 2.5], ["19", 2.6667], ["16", 2.75],
    ["24", 2.8], ["14", 2.8571], ["23", 3.0], ["29", 3.0], ["7", 3.0], ["4", 3.3333]]
      expect(stat_tracker.team_score_averages).to eq(expected_array)
    end

    it 'can calculate #best_offense' do
      expect(stat_tracker.best_offense).to eq("Chicago Fire")
    end

    it 'can calculate #worst_offense' do
      expect(stat_tracker.worst_offense).to eq("Sporting Kansas City")
    end

    it "#team_info" do
      expected = {
        "team_id" => "18",
        "franchise_id" => "34",
        "team_name" => "Minnesota United FC",
        "abbreviation" => "MIN",
        "link" => "/api/v1/teams/18"
        }
      expect(stat_tracker.team_info("18")).to eq expected
    end

    it 'can calculate the highest_scoring_visitor' do
      expect(stat_tracker.highest_scoring_visitor).to eq("Chicago Fire")
    end

    it 'can produce an array_of_gameids by season' do
      expect(stat_tracker.array_of_gameids_by_season("20122013")).to be_an(Array)
      expect(stat_tracker.array_of_gameids_by_season("20122013")[0]).to be_a(String)
      expect(stat_tracker.array_of_gameids_by_season("20122013")[0].length).to eq(10)
    end

    it 'can produce an array_of_game_teams by season' do
      expect(stat_tracker.array_of_game_teams_by_season("20122013")).to be_an(Array)
      expect(stat_tracker.array_of_game_teams_by_season("20122013")[0]).to be_a(GameTeam)
    end

    it 'can calculate win percentages for coaches and organize them' do
      expect(stat_tracker.coaches_win_percentages_hash("20122013")).to be_a(Hash)
      expect(stat_tracker.coaches_win_percentages_hash("20122013").first[1]).to be_a(Float)
    end

    it 'can find the winningest coach' do
      expect(stat_tracker.winningest_coach("20122013")).to be_a(String)
    end

    it 'can find the worst coach' do
      expect(stat_tracker.winningest_coach("20122013")).to be_a(String)
    end

    it "#most_tackles returns team with the most tackles in the season " do
      expect(stat_tracker.most_tackles("20122013")).to eq("Houston Dynamo")
    end

    it '#fewest_tackles returns team with the least tackles in the season' do
      expect(stat_tracker.fewest_tackles("20122013")).to eq("FC Dallas")
    end
    ##TEAM STATISTICS BELOW
    it '#game_ids_seasons helper method for #best_season and #worst_season' do
      expect(stat_tracker.game_ids_seasons("6")).to be_a(Hash)
    end

    it '#seasons_perc_win helper method for #best_season and #worst_season' do
      expect(stat_tracker.seasons_perc_win("6")).to eq([["20122013", 1.0]])
    end

    it 'returns the #best_season with the highest win percentage for a team' do
      expect(stat_tracker.best_season("6")).to be_an(String)
    end

    it 'returns the #worst_season with the highest win percentage for a team' do
      expect(stat_tracker.worst_season("6")).to be_an(String)
    end
  
    it 'can generate goals_scored_sorted as an array' do
      expect(stat_tracker.goals_scored_sorted("6")).to be_an(Array)
      expect(stat_tracker.goals_scored_sorted("6").first).to be_an(Integer)
      expect(stat_tracker.goals_scored_sorted("6").last).to be_an(Integer)
    end

    it 'can find the most_goals_scored for a team' do
      expect(stat_tracker.most_goals_scored("6")).to be_an(Integer)
      expect(stat_tracker.most_goals_scored("6")).to eq(3)
    end

    it 'can find the fewest goals_scored for a team' do
      expect(stat_tracker.fewest_goals_scored("6")).to be_an(Integer)
      expect(stat_tracker.fewest_goals_scored("6")).to eq(1)
    end

    it 'can find_team_name(team_id)' do
      expect(stat_tracker.find_team_name("6")).to eq("FC Dallas")
    end

    it 'can #find_game_id_arr(team_id)' do
      expected_arr = ["2012030311", "2012030312", "2012030313", "2012030314"]
      expect(stat_tracker.find_game_id_arr("5")).to eq(expected_arr)
    end

    it 'can give #opponents_win_percenage(team_id) array of arrays' do
    # need different fixture data to show more dynamic expect
      expect(stat_tracker.opponents_win_percentage("6")).to eq([["3", 0.0], ["5", 0.0]])
    end

    it 'can find #favorite_opponent(team_id)' do
    # currently works with './data/fixtures/game_teams_i1.csv'
    # In order to test 100% properly, fixture data for game_teams must contain several
    # "matchups", where the argument team has several opponents with matching game_id.
    # './data/fixtures/game_teams_i2.csv' does not contain enough "matchups"
      expect(stat_tracker.favorite_opponent("6")).to eq("Houston Dynamo")
    end

    it 'can find #rival(team_id)' do
    # currently works with './data/fixtures/game_teams_i1.csv'
    # In order to test 100% properly, fixture data for game_teams must contain several
    # "matchups", where the argument team has several opponents with matching game_id.
    # './data/fixtures/game_teams_i2.csv' does not contain enough "matchups"
      expect(stat_tracker.rival("6")).to eq("Sporting Kansas City")
    end
  end

  describe 'new game_team dummy data' do
    let(:game_path_2){'./data/fixtures/games_i2.csv'}
    let(:game_teams_path_2){'./data/fixtures/game_teams_i2.csv'}
    #note that we will need to edit team/game_team paths if new fixture data is created for use in these tests
    
    let(:locations_3){{
      games: game_path_2,
      teams: team_path,
      game_teams: game_teams_path_2
    }}
  
    let(:stat_tracker) {StatTracker.from_csv(locations_3)}

    it "#most_accurate_team" do
      expect(stat_tracker.most_accurate_team("20132014")).to eq "Toronto FC"
      expect(stat_tracker.most_accurate_team("20142015")).to eq "Orlando Pride"
    end

    it "#least_accurate_team" do
      expect(stat_tracker.least_accurate_team("20132014")).to eq "LA Galaxy"
      expect(stat_tracker.least_accurate_team("20142015")).to eq "Chicago Red Stars"
    end

    it "#average_win_percentage" do
      expect(stat_tracker.average_win_percentage("26")).to eq 0.67
    end
  end
end