module SeasonStatsable

  def winningest_coach(season)
    coaches_win_percentages_hash(season).sort_by{|k,v| v}.last[0]
  end
  
  def worst_coach(season)
    coaches_win_percentages_hash(season).sort_by{|k,v| v}.first[0]
  end

  def most_accurate_team(season)
    sorted_teams = team_ratio_hash(season).sort_by {|key, value| value}
    mat = teams.find do |team|
      team.team_id == sorted_teams.last[0]
    end
    mat.team_name
  end

  def least_accurate_team(season)
    sorted_teams = team_ratio_hash(season).sort_by {|key, value| value}
    lat = teams.find do |team|
      team.team_id == sorted_teams.first[0]
    end
    lat.team_name
  end
  
  def most_tackles(season)
      most_tackles_id = team_total_tackles(season).sort_by { |k, v| v }.last.first
      teams.each do |team|
        return team.team_name if team.team_id == most_tackles_id
      end
  end  

  def fewest_tackles(season)
    fewest_tackles_id = team_total_tackles(season).sort_by { |k, v| v }.first.first
    teams.each do |team|
      return team.team_name if team.team_id == fewest_tackles_id
    end
  end
end