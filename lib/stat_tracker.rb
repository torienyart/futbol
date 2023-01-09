require 'csv'
require_relative 'game.rb'
require_relative 'team.rb'
require_relative 'game_team.rb'
require_relative 'data_factory.rb'

class StatTracker < DataFactory
  attr_reader :games,
              :teams,
              :game_teams

  def initialize(games, teams, game_teams)
    @games = games
    @teams = teams
    @game_teams = game_teams
  end
  
  ## GAME STATISTIC METHODS
   def game_score_totals_sorted
      games.map do |game|
        game.home_goals.to_i + game.away_goals.to_i
      end.sort
    end
  
    def highest_total_score
      game_score_totals_sorted.last
    end             

    def lowest_total_score
      game_score_totals_sorted.first
    end

    def home_wins
      home_wins = games.count do |game|
        game.home_goals.to_i > game.away_goals.to_i
      end
    end

    def away_wins
      away_wins = games.count do |game|
        game.away_goals.to_i > game.home_goals.to_i
      end
    end

    def tie_games
      ties = games.count do |game|
        game.away_goals.to_i == game.home_goals.to_i
      end
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
      hash = {}

      seasons = games.map do |game|
        game.season
      end.uniq.sort

      seasons.each do |season|
        hash[season] = []
      end
      
      games.each do |game|
        hash[game.season] << game
      end

      hash.each do |k, v|
        hash[k] = v.count
      end

      hash
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

    def goals_per_game(game)
      game.away_goals.to_i + game.home_goals.to_i
    end

    def average_goals_per_game
      total_goals = games.reduce(0) do |sum, game|
        sum + goals_per_game(game)
      end

      (total_goals.to_f/games.length).round(2)
    end
    
    def average_goals_by_season
      hash = count_of_games_by_season
      
      hash.each do |k, v|
        hash[k] = (goals_per_season(k, v)/v.to_f).round(2)
      end

      hash
    end

  ## LEAGUE STATISTIC METHODS
    def count_of_teams
      teams.count
    end

    def visitor_score_averages
        team_id_hash = Hash.new{|h,v| h[v] = []}
      games.each do |game|
        team_id_hash[game.away_team_id] << game.away_goals.to_f
      end

      average_hash = Hash.new
      team_id_hash.each do |team_id, score_array|
       average_hash[team_id] = (score_array.sum / score_array.size).round(4)
      end

      average_hash.sort_by{|key, value| value}
    end

    def home_score_averages
      team_id_hash = Hash.new{|h,v| h[v] = []}
      games.each do |game|
        team_id_hash[game.home_team_id] << game.home_goals.to_f
      end
      average_hash = Hash.new
      team_id_hash.each do |team_id, score_array|
        average_hash[team_id] = (score_array.sum / score_array.size).round(4)
      end
      average_hash.sort_by{|key, value| value}
    end

    def lowest_scoring_home_team
      sorted_avgs = home_score_averages
      lowest_score = sorted_avgs.first[1]

      lowests = []
      sorted_avgs.each do |array|
        lowests << array.first if array.last == lowest_score
      end
      
      lowest_scoring_home = []
      lowests.each do |id|
        teams.each do |team|
          lowest_scoring_home << team.team_name if team.team_id == id
        end
      end
      lowest_scoring_home.join(", ")
    end

    def highest_scoring_home_team
      highest_score = home_score_averages.last[1]

      highests = []
      home_score_averages.each do |array|
        highests << array.first if array.last == highest_score
      end

      highest_scoring_home = []
      highests.each do |id|
        teams.each do |team|
          highest_scoring_home << team.team_name if team.team_id == id
        end
      end
      highest_scoring_home.join(", ")
    end
     
    def lowest_scoring_visitor
      sorted_avgs = visitor_score_averages
      lowest_score = sorted_avgs.first[1]

      lowests = []
      sorted_avgs.each do |array|
        lowests << array.first if array.last == lowest_score
      end

      lowest_scoring_visitors = []
      lowests.each do |id|
        teams.each do |team|
          lowest_scoring_visitors << team.team_name if team.team_id == id
        end
      end
      lowest_scoring_visitors.join(", ")
    end

    def highest_scoring_visitor
      highest_score = visitor_score_averages.last[1]

      highests = []
      visitor_score_averages.each do |array|
        highests << array.first if array.last == highest_score
      end

      highest_scoring_visitors = []
      highests.each do |id|
        teams.each do |team|
          highest_scoring_visitors << team.team_name if team.team_id == id
        end
      end
      highest_scoring_visitors.join(", ")
    end

    def array_of_gameids_by_season(season)
      games_by_season = games.find_all do |game|     
        game.season == season
      end

     game_ids_arr = games_by_season.map do |game|
        game.game_id
      end
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

    def best_offense
      sorted_avgs = team_score_averages
      highest_score = sorted_avgs.last[1]

      highest = []
      sorted_avgs.each do |array|
        highest << array.first if array.last == highest_score
      end

      highest_scoring_team = []
      highest.each do |id|
        teams.each do |team|
          highest_scoring_team << team.team_name if team.team_id == id
        end
      end
      highest_scoring_team.join(", ")
    end

    def worst_offense
      sorted_avgs = team_score_averages
      lowest_score = sorted_avgs.first[1]

      lowest = []
      sorted_avgs.each do |array|
        lowest << array.first if array.last == lowest_score
      end

      lowest_scoring_team = []
      lowest.each do |id|
        teams.each do |team|
          lowest_scoring_team << team.team_name if team.team_id == id
        end
      end
      lowest_scoring_team.join(", ")
    end

  ## SEASON STATISTICS METHODS
    def array_of_game_teams_by_season(season)
      game_teams_arr = []
      array_of_gameids_by_season(season).each do |game_id|
        game_teams.each do |game_team|
          game_teams_arr << game_team if game_team.game_id == game_id
        end
      end
      game_teams_arr
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

    def winningest_coach(season)
      sorted = coaches_win_percentages_hash(season).sort_by{|k,v| v}
      sorted.last[0]
    end
    
    def worst_coach(season)
      sorted = coaches_win_percentages_hash(season).sort_by{|k,v| v}
      sorted.first[0]
    end
    
    def most_tackles(season)
      team_total_tackles = Hash.new{|h,v| h[v] = 0 }
      game_team_array = array_of_game_teams_by_season(season) 
        game_team_array.each do |game_team|
          team_total_tackles[game_team.team_id] += game_team.tackles.to_i
        end
        most_tackles_id = team_total_tackles.sort_by { |k, v| v }.last.first
        teams.each do |team|
          return team.team_name if team.team_id == most_tackles_id
        end
    end  

    def fewest_tackles(season)
      team_total_tackles = Hash.new{|h,v| h[v] = 0 }
      game_team_array = array_of_game_teams_by_season(season) 
        game_team_array.each do |game_team|
          team_total_tackles[game_team.team_id] += game_team.tackles.to_i
        end
        fewest_tackles_id = team_total_tackles.sort_by { |k, v| v }.first.first
        teams.each do |team|
          return team.team_name if team.team_id == fewest_tackles_id
        end
    end  

  ##TEAM STATISTICS METHODS
    def goals_scored_sorted(teamid)
      game_scores = []
     
      games.each do |game|
        game_scores << game.home_goals.to_i if game.home_team_id == teamid
        game_scores << game.away_goals.to_i if game.away_team_id == teamid
      end
      game_scores.sort
    end

    def most_goals_scored(teamid)
      goals_scored_sorted(teamid).last
    end

    def fewest_goals_scored(teamid)
      goals_scored_sorted(teamid).first
    end
    
    def find_team_id(team_id)
      teams.find do |team|
        team.team_id == team_id
      end
    end

    def team_info(team_id)
      hash = {}
      team = find_team_id(team_id)
      hash["team_id"] = team.team_id
      hash["franchise_id"] = team.franchise_id
      hash["team_name"] = team.team_name
      hash["abbreviation"] = team.abbreviation
      hash["link"] = team.link

      hash
    end

    def team_ratio_hash(season)
      goals_hash = {}
      shots_hash = {}
      team_ratio_hash = {}

      season_games = game_teams.find_all do |game_team|
        game_team.game_id[0..3] == season[0..3]
      end

      season_games.each do |game_team|
        goals_hash[game_team.team_id] = 0
        shots_hash[game_team.team_id] = 0
      end
      season_games.each do |game_team|
        goals_hash[game_team.team_id] += game_team.goals.to_i
        shots_hash[game_team.team_id] += game_team.shots.to_i
      end
      
      goals_hash.each do |team, goals|
        team_ratio_hash[team] = goals.to_f/shots_hash[team]
      end
      team_ratio_hash
    end
    
    def most_accurate_team(season)
      # = Name of the Team with the best ratio of shots to goals for the season
      #need to pull all games from a given season
      team_ratio_hash = team_ratio_hash(season)

      sorted_teams = team_ratio_hash.sort_by {|key, value| value}
      
      mat = teams.find do |team|
        team.team_id == sorted_teams.last[0]
      end
      
      mat.team_name
    end

    def least_accurate_team(season)
      team_ratio_hash = team_ratio_hash(season)
      sorted_teams = team_ratio_hash.sort_by {|key, value| value}

      lat = teams.find do |team|
        team.team_id == sorted_teams.first[0]
      end
      
      lat.team_name
    end

    def average_win_percentage(team)
      team_games = []
      won = []

      game_teams.each do |game_team|
        if game_team.team_id == team
          team_games << game_team
        end
      end

      team_games.each do |team_game|
        if team_game.result == "WIN"
          won << team_game
        end
      end

      (won.count.to_f / team_games.count).round(2)
    end

    def find_game_id_arr(team_id)
      all_games = game_teams.find_all do |team|
        team.team_id == team_id
      end

      all_games.map do |game|
        game.game_id
      end
    end

    def opponents_win_percentage(team_id)
      opponents_wins = Hash.new{ |h,v| h[v] = [] }
      find_game_id_arr(team_id).each do |game_id|
        game_teams.each do |game_team|
          opponents_wins[game_team.team_id] << game_team.result if game_team.game_id == game_id && game_team.team_id != team_id
        end
      end
      
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

    def favorite_opponent(team_id)
      favorite_id = opponents_win_percentage(team_id).first.first
      find_team_name(favorite_id)
    end

    def rival(team_id)
      favorite_id = opponents_win_percentage(team_id).last.first
      find_team_name(favorite_id)
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

    def best_season(team_id)
      seasons_perc_win(team_id).last.first
    end

    def worst_season(team_id)
      seasons_perc_win(team_id).first.first
    end
end