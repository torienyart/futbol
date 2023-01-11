require 'csv'
require_relative 'team'
require_relative 'game'
require_relative 'game_team'
require_relative 'data_factory'
require_relative 'modules/helper_methods'
require_relative 'modules/game_stats'
require_relative 'modules/league_stats'
require_relative 'modules/season_stats'
require_relative 'modules/team_stats'

class StatTracker < DataFactory
  include Helpable
  include GamesStatsable
  include LeagueStatsable
  include SeasonStatsable
  include TeamStatsable
  attr_reader :games,
              :teams,
              :game_teams

  def initialize(games, teams, game_teams)
    @games = games
    @teams = teams
    @game_teams = game_teams
  end
end