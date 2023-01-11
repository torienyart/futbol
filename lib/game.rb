# require './lib/stat_tracker'
require_relative 'data_factory'

require_relative 'modules/helper_methods'

class Game < DataFactory
include Helpable
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

		def game_score_totals_sorted
			games.map { |game| game.home_goals.to_i + game.away_goals.to_i }.sort
		end
	
		def home_wins
			games.count { |game| game.home_goals.to_i > game.away_goals.to_i }
		end
	
		def away_wins
			games.count { |game| game.away_goals.to_i > game.home_goals.to_i }
		end
	
		def tie_games
			games.count { |game| game.away_goals.to_i == game.home_goals.to_i }
		end
#===================
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
  end