defmodule Fantasy.NumberfireScraper do
	require Logger

	@weekly_url  "https://www.numberfire.com/nfl/fantasy/fantasy-football-projections"
	@stat_fields ["pass_yd", "pass_td", "pass_int", "rush_att", "rush_td", "rec", "rec_td"]

	def scrape do
		Logger.info("Starting HTTPoison server")
		HTTPoison.start
		resp = HTTPoison.get! @weekly_url
		# parse all players from the 
		stats = Floki.find(resp.body, "table.projection-table, .no-fix > tbody.projection-table__body > tr[data-row-index]")
		[{ _, _, players} | _ ] = 	Floki.find(resp.body, ".data-table-wrap, .projection-table__body, .projection-table--fixed > tr[data-row-index]")
		
		projections = players
						|> Enum.map(&Fantasy.NumberfireScraper.process_name_row_for_row_index_pair(&1))
						|> Enum.map(&Fantasy.NumberfireScraper.scrape_stats(&1,stats))
	end

	def process_name_row_for_row_index_pair(player) do
		%{name: get_name(player) , index: get_index(player)}
	end

	def get_name(player) do
		case Floki.find(player, ".full") do
			[{ _, _, [ name | _ ]} | _ ] -> String.downcase(name)
			[] -> 'UNKNOWN'
		end
	end

	def get_index(player) do
		Floki.attribute(player, "data-row-index")
	end

	def scrape_stats(player, stats) do
		[index | _ ] = Map.fetch!(player, :index)
		player_stats = Floki.find(stats, "[data-row-index='#{index}'")

		scraped_stats = @stat_fields
				|> Enum.reduce(%{}, fn(curr, map) -> 
						Map.put(map, curr, get_val(Floki.find(player_stats, ".#{curr}")))
					end)
		Map.put(player, "stats", scraped_stats)
	end

	def get_val([]), do: 0
	def get_val([{ _, _, [value_string | _] } | _]) do
		# do something to the value string
		value = value_string
					|> String.replace(" ", "")
					|> String.replace("\n", "")
		  			|> Float.parse 
		  			
		case value do
			{val, _} -> val
			:error -> 0
		end
	end
end