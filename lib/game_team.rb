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