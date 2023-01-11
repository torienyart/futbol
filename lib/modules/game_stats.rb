module GamesStatsable

  def highest_total_score
    game_score_totals_sorted.last
  end             

  def lowest_total_score
    game_score_totals_sorted.first
  end
  
  def percentage_home_wins
    (home_wins.to_f / games.length).round(2)
  end

  def percentage_visitor_wins
    (away_wins.to_f / games.length).round(2)
  end

  def percentage_ties
    (tie_games.to_f / games.length).round(2)
  end

  def count_of_games_by_season  
    count_of_games_by_season = {}
    hash_of_games_by_season.each do |k, v|
      count_of_games_by_season[k] = v.count
    end
    count_of_games_by_season
  end

  def average_goals_per_game
    (total_goals/games.length).round(2)
  end
  
  def average_goals_by_season
    hash = count_of_games_by_season
    hash.each do |k, v|
      hash[k] = (goals_per_season(k)/v.to_f).round(2)
    end
    hash
  end

end