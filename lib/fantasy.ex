defmodule Fantasy do
	use Application
	require Logger

	def process_week(week) do
		Logger.info("processing week #{week}")
		projections = Fantasy.NumberfireScraper.scrape
		Logger.info("#{inspect projections}")
		calculated = Fantasy.Calculator.apply_scoring(projections)
	end

end
