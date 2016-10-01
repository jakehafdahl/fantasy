defmodule Fantasy.ScoringSetting do
	@derive [Poison.Encoder]
  	defstruct position: 'RB', field: 'rush_yd', points_for: 0, required_per: 1
end