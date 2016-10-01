defmodule Fantasy.Calculator do
	require Logger
		
	def apply_scoring(projections, stuff \\ []) do
		projections
	end

	# def apply_scoring(projections, scoring) do
		
	# end
	def apply_setting(a, _) when a == :null, do: 0
	def apply_setting(_, a) when a == :null, do: 0
  	def apply_setting(player_projection, %Fantasy.ScoringSetting{ field: field, points_for: points_for, required_per: required_per}) do
  		amt = Map.get(player_projection, String.to_atom(field))
  		( amt / required_per) * points_for
  	end
end