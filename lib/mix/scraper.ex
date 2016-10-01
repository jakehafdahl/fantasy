require Logger

defmodule Mix.Tasks.Fantasy.Scraper do

  use Mix.Task

  @shortdoc "Starts the server"

  @moduledoc """
  Starts the Elixir Fake IM server.
  ## Command line options
  This task accepts the same command-line arguments as `run`.
  For additional information, refer to the documentation for
  `Mix.Tasks.Run`.
  """
  def run(argv) do
    Logger.info("Starting Fantasy Scraper...")
    argv
    |> parse_args
    |> process
  end

  def parse_args(args) do
    arguments = OptionParser.parse(args, switches: [week: :integer,
                                                    year: :boolean,
                                                    scoringpath: :string],
                                          aliases: [w: :week,
                                                    y: :year,
                                                    sp: :scoringpath])

    case arguments do
      {args = [week: week_number, scoringpath: path], _, _} -> args
      {[week: week_number], _, _} -> [week: week_number]
      {[year: true], _, _}        -> :year
    end
      
  end

  def process([week: week_number]), do: process([week: week_number, scoringpath: "default.json"])
  def process([week: week_number, scoringpath: scoringpath]) do
    projections = Fantasy.NumberfireScraper.scrape
    {:ok, content} = File.read(scoringpath)
    {:ok, scoring} = Poison.decode(content, as: [%Fantasy.ScoringSetting{}])
    scores = Fantasy.Calculator.apply_scoring(projections, scoring)
    IO.puts "#{inspect scores}"
  end
end
