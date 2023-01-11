module LeagueStatsable

   def count_of_teams
    teams.count
  end

  def best_offense
    find_team_name(team_score_averages.last[0])
  end

  def worst_offense
    find_team_name(team_score_averages.first[0])
  end

  def highest_scoring_visitor
    find_team_name(visitor_score_averages.last[0])
  end

  def highest_scoring_home_team
    find_team_name(home_score_averages.last[0])
  end

  def lowest_scoring_visitor
    find_team_name(visitor_score_averages.first[0])
  end

  def lowest_scoring_home_team
    find_team_name(home_score_averages.first[0])
  end
end