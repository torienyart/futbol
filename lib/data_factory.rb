class DataFactory
  def self.from_csv(locations)
    games = games_csv(locations)
    teams = teams_csv(locations)
    game_teams = game_teams_csv(locations)
    StatTracker.new(games, teams, game_teams)
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
end