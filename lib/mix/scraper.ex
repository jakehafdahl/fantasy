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
                                                    year: :boolean],
                                          aliases: [w: :week,
                                                    y: :year])

    case arguments do
      {[week: week_number], _, _} -> [week: week_number]
      {[year: true], _, _}        -> :year
    end
      
  end

  def process([week: week_number]) do
    Fantasy.process_week(week_number)
  end
end
