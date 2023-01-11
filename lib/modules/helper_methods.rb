module Helpable

  # def game_score_totals_sorted
  #   games.map { |game| game.home_goals.to_i + game.away_goals.to_i }.sort
  # end

  # def home_wins
  #   games.count { |game| game.home_goals.to_i > game.away_goals.to_i }
  # end

  # def away_wins
  #   games.count { |game| game.away_goals.to_i > game.home_goals.to_i }
  # end

  # def tie_games
  #   games.count { |game| game.away_goals.to_i == game.home_goals.to_i }
  # end

  def goals_per_game(game)
    game.away_goals.to_i + game.home_goals.to_i
  end

  def goals_per_season(season, num_games)
    goal_counter = 0
    games.each do |game|
      if game.season == season
        goal_counter += goals_per_game(game)
      end
    end
    goal_counter
  end

  def team_score_averages
    team_id_hash = Hash.new{|h,v| h[v] = []}
    games.each do |game|
      team_id_hash[game.away_team_id] << game.away_goals.to_f
      team_id_hash[game.home_team_id] << game.home_goals.to_f
    end
    goal_average_hash = Hash.new
    team_id_hash.each do |team_id, score_array|
      goal_average_hash[team_id] = (score_array.sum / score_array.size).round(4)
    end
    goal_average_hash.sort_by{|key, value| value}
  end

  def team_id_and_score_array_hash(away_or_home)
    team_id_hash = Hash.new{|h,v| h[v] = []}
    games.each { |game| team_id_hash[game.away_team_id] << game.away_goals.to_f } if 
      away_or_home == :away
    games.each { |game| team_id_hash[game.home_team_id] << game.home_goals.to_f } if 
      away_or_home == :home
    team_id_hash
  end

  def score_averages(away_or_home)
    average_hash = Hash.new
    team_id_and_score_array_hash(away_or_home).each do |team_id, score_array|
      average_hash[team_id] = (score_array.sum / score_array.size).round(4)
    end
    average_hash.sort_by{|key, value| value}
  end
  
  def visitor_score_averages
    score_averages(:away)
  end

  def home_score_averages
    score_averages(:home)
  end

  def coaches_win_percentages_hash(season)
    coaches_hash = Hash.new{|h,v| h[v] = []}
    array_of_game_teams_by_season(season).each do |game_team|
      coaches_hash[game_team.head_coach] << game_team.result
    end

    coaches_hash.each do |coach, result_arr|
      percent = (result_arr.count("WIN").to_f/result_arr.size)*100
      coaches_hash[coach] = percent
    end
  end

  def team_ratio_hash(season)
    team_ratio_hash = {}
    goals_hash = Hash.new{|h,v| h[v] = 0}
    shots_hash = Hash.new{|h,v| h[v] = 0}

    game_teams.find_all do |game_team|
      game_team.game_id[0..3] == season[0..3]
    end.each do |game_team|
      goals_hash[game_team.team_id] += game_team.goals.to_i
      shots_hash[game_team.team_id] += game_team.shots.to_i
    end

    goals_hash.each do |team, goals|
      team_ratio_hash[team] = goals.to_f/shots_hash[team]
    end
    team_ratio_hash
  end

  def array_of_gameids_by_season(season)
    games_by_season = games.find_all do |game|     
      game.season == season
    end

    game_ids_arr = games_by_season.map do |game|
      game.game_id
    end
  end

  def array_of_game_teams_by_season(season)
    game_teams_arr = []
    array_of_gameids_by_season(season).each do |game_id|
      game_teams.each do |game_team|
        game_teams_arr << game_team if game_team.game_id == game_id
      end
    end
    game_teams_arr
  end

  def find_team_by_id(team_id)
    teams.find { |team| team.team_id == team_id }
  end

  def game_ids_seasons(team_id)
    seasons_hash = Hash.new{|h,v| h[v] = []}
    games.each do |game| 
      seasons_hash[game.season] << game.game_id
    end  
    seasons_hash
  end
  
  def seasons_perc_win(team_id)
    wins_by_seasons = Hash.new{|h,v| h[v] = []}
    game_ids_seasons = game_ids_seasons(team_id)
    game_ids_seasons.each do |season, game_ids_arr| 
      game_ids_arr.each do |game_id|
        game_teams.each do |game_team| 
          wins_by_seasons[season] << game_team.result if game_id == game_team.game_id && team_id == game_team.team_id
        end
      end
    end
    wins_by_seasons.each do |season, array|
      wins_by_seasons[season] = (array.count("WIN")/ array.size.to_f) 
    end
    wins_by_seasons.sort_by { |k, v| v }
  end

  def goals_scored_sorted(teamid)
    game_scores = []

    games.each do |game|
      game_scores << game.home_goals.to_i if game.home_team_id == teamid
      game_scores << game.away_goals.to_i if game.away_team_id == teamid
    end
    game_scores.sort
  end

  def find_game_id_arr(team_id)
    all_games = game_teams.find_all { |team| team.team_id == team_id }

    all_games.map { |game| game.game_id }
  end

  def opponents_match_results(team_id)
    opponents_results = Hash.new{ |h,v| h[v] = [] }
    find_game_id_arr(team_id).each do |game_id|
      game_teams.each do |game_team|
        opponents_results[game_team.team_id] << game_team.result if 
        game_team.game_id == game_id && game_team.team_id != team_id
      end
    end
    opponents_results
  end

  def opponents_win_percentage(team_id)
    opponents_wins = opponents_match_results(team_id)
    opponents_wins.each do |team_id, result_array|
      percent = result_array.count("WIN").to_f / result_array.size
      opponents_wins[team_id] = percent
    end
    opponents_wins.sort_by{|k,v| v}
  end

  def find_team_name(team_id)
    teams.each do |team|
      return team.team_name if team.team_id == team_id
    end
  end

  def team_total_tackles(season)
    team_total_tackles = Hash.new{|h,v| h[v] = 0 }
    game_team_array = array_of_game_teams_by_season(season)
    game_team_array.each do |game_team|
      team_total_tackles[game_team.team_id] += game_team.tackles.to_i
    end
    team_total_tackles
  end    

  def hash_of_games_by_season
    hash = Hash.new{|h,v| h[v] = []}

    games.each do |game|
      hash[game.season] << game
    end
    hash
  end

  def total_goals
    games.reduce(0) do |sum, game|
      sum + goals_per_game(game)
    end.to_f
  end

end  