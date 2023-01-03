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
    CSV.foreach(locations[:games], headers: true) do |info|
      games << Game.new(info)
    end
    games
  end

  def self.teams_csv(locations)
    teams = []
    CSV.foreach(locations[:teams], headers: true) do |info|
      teams << Team.new(info)
    end
    teams
  end

  def self.game_teams_csv(locations)
    game_teams = []
    CSV.foreach(locations[:game_teams], headers: true) do |info|
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
      @game_id = info["game_id"]
      @season = info["season"]
      @type = info["type"]
      @date_time = info["date_time"]
      @away_team_id = info["away_team_id"]
      @home_team_id = info["home_team_id"]
      @away_goals = info["away_goals"]
      @home_goals = info["home_goals"]
      @venue = info["venue"]
      @venue_link = info["venue_link"]
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
      @team_id = info["team_id"]
      @franchise_id = info["franchiseId"]
      @team_name = info["teamName"]
      @abbreviation = info["abbreviation"]
      @stadium = info["Stadium"]
      @link = info["link"]
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
      @game_id = info["game_id"]
      @team_id = info["team_id"]
      @hoa = info["HoA"]
      @result = info["result"]
      @settled_in = info["settled_in"]
      @head_coach = info["head_coach"]
      @goals = info["goals"]
      @shots = info["shots"]
      @tackles = info["tackles"]
      @pim = info["pim"]
      @power_play_opportunities = info["powerPlayOpportunities"]
      @power_play_goals = info["powerPlayGoals"]
      @face_off_win_percentage = info["faceOffWinPercentage"]
      @giveaways = info["giveaways"]
      @takeaways = info["takeaways"]

    end
  end
  
end