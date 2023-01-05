require 'csv'

class StatTracker
  attr_reader :games,
              :teams,
              :game_teams

  def initialize(games, teams, game_teams)
    @games = games
    @teams = teams
    @game_teams = game_teams
  end
  
  def self.from_csv(locations)
    games = games_csv(locations)
    teams = teams_csv(locations)
    game_teams = game_teams_csv(locations)
    self.new(games, teams, game_teams)
  end

  def self.games_csv(locations)
    games = []
    CSV.foreach(locations[:games], headers: true, header_converters: :symbol) do |info|
      games << Game.new(info)
    end
    games
  end

  def self.teams_csv(locations)
    teams = []
    CSV.foreach(locations[:teams], headers: true, header_converters: :symbol) do |info|
      teams << Team.new(info)
    end
    teams
  end

  def self.game_teams_csv(locations)
    game_teams = []
    CSV.foreach(locations[:game_teams], headers: true, header_converters: :symbol) do |info|
      game_teams << GameTeam.new(info)
    end
    game_teams
  end

  class Game
    attr_reader :game_id,
                :season,
                :type,
                :date_time,
                :away_team_id,
                :home_team_id,
                :away_goals,
                :home_goals,
                :venue,
                :venue_link

    def initialize(info)
      @game_id = info[:game_id]
      @season = info[:season]
      @type = info[:type]
      @date_time = info[:date_time]
      @away_team_id = info[:away_team_id]
      @home_team_id = info[:home_team_id]
      @away_goals = info[:away_goals]
      @home_goals = info[:home_goals]
      @venue = info[:venue]
      @venue_link = info[:venue_link]
    end

    def goals_per_game
      away_goals.to_i + home_goals.to_i
    end

  end

  class Team
    attr_reader :team_id,
                :franchise_id,
                :team_name,
                :abbreviation,
                :stadium,
                :link
                
    def initialize(info)
      @team_id = info[:team_id]
      @franchise_id = info[:franchiseid]
      @team_name = info[:teamname]
      @abbreviation = info[:abbreviation]
      @stadium = info[:stadium]
      @link = info[:link]
    end
  end

  class GameTeam
    attr_reader :game_id,
                :team_id,
                :hoa,
                :result,
                :settled_in,
                :head_coach,
                :goals,
                :shots,
                :tackles,
                :pim,
                :power_play_opportunities,
                :power_play_goals,
                :face_off_win_percentage,
                :giveaways,
                :takeaways

    def initialize(info)
      @game_id = info[:game_id]
      @team_id = info[:team_id]
      @hoa = info[:hoa]
      @result = info[:result]
      @settled_in = info[:settled_in]
      @head_coach = info[:head_coach]
      @goals = info[:goals]
      @shots = info[:shots]
      @tackles = info[:tackles]
      @pim = info[:pim]
      @power_play_opportunities = info[:powerplayopportunities]
      @power_play_goals = info[:powerplaygoals]
      @face_off_win_percentage = info[:faceoffwinpercentage]
      @giveaways = info[:giveaways]
      @takeaways = info[:takeaways]
    end
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
      (home_wins.to_f * 100 / games.length).round(2)
    end

    def percentage_visitor_wins
      (away_wins.to_f * 100 / games.length).round(2)
    end

    def percentage_ties
      (tie_games.to_f * 100 / games.length).round(2)
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
          goal_counter += game.goals_per_game 
        end
      end
      goal_counter
    end
    
    def average_goals_per_game
      total_goals = games.reduce(0) do |sum, game|
        sum + game.goals_per_game
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

    def lowest_scoring_visitor
      team_id_hash = Hash.new{|h,v| h[v] = []}
      games.each do |game|
        team_id_hash[game.away_team_id] << game.away_goals.to_f
      end
      # require 'pry'; binding.pry

      average_hash = Hash.new
      team_id_hash.each do |team_id, score_array|
       average_hash[team_id] = (score_array.sum. / score_array.size).round(4)
      end
      lowest_id = average_hash.sort_by{|key, value| value}.first[0]

      teams.each do |team|
        if team.team_id == lowest_id
          return team.team_name
        end
      end
    end

    def best_offense
      team_id_hash_2 = Hash.new{|h,v| h[v] = []}
      games.each do |game|
        team_id_hash_2[game.away_team_id] << game.away_goals.to_f
        team_id_hash_2[game.home_team_id] << game.home_goals.to_f
      end

      average_hash_2 = Hash.new
      team_id_hash_2.each do |team_id, score_array|
       average_hash_2[team_id] = (score_array.sum. / score_array.size).round(4)
      end
      
      highest_id = average_hash_2.sort_by{|key, value| value}.last[0]

      teams.each do |team|
        if team.team_id == highest_id
          return team.team_name
        end
      end
    end

    def worst_offense
      team_id_hash_2 = Hash.new{|h,v| h[v] = []}
      games.each do |game|
        team_id_hash_2[game.away_team_id] << game.away_goals.to_f
        team_id_hash_2[game.home_team_id] << game.home_goals.to_f
      end

      average_hash_2 = Hash.new
      team_id_hash_2.each do |team_id, score_array|
       average_hash_2[team_id] = (score_array.sum. / score_array.size).round(4)
      end
      
      lowest_id = average_hash_2.sort_by{|key, value| value}.first[0]

      teams.each do |team|
        if team.team_id == lowest_id
          return team.team_name
        end
      end
    end

    

end


