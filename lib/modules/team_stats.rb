module TeamStatsable

  def team_info(team_id)
    hash = {}
    team = find_team_by_id(team_id)
    hash["team_id"] = team.team_id
    hash["franchise_id"] = team.franchise_id
    hash["team_name"] = team.team_name
    hash["abbreviation"] = team.abbreviation
    hash["link"] = team.link

    hash
  end

  def best_season(team_id)
    seasons_perc_win(team_id).last.first
  end

  def worst_season(team_id)
    seasons_perc_win(team_id).first.first
  end

  def average_win_percentage(team)
    (won_games_by_team(team).count.to_f/games_by_team(team).count).round(2)
  end

  def most_goals_scored(teamid)
    goals_scored_sorted(teamid).last
  end

  def fewest_goals_scored(teamid)
    goals_scored_sorted(teamid).first
  end

  def favorite_opponent(team_id)
    favorite_id = opponents_win_percentage(team_id).first.first
    find_team_name(favorite_id)
  end

  def rival(team_id)
    rival_id = opponents_win_percentage(team_id).last.first
    find_team_name(rival_id)
  end 
end