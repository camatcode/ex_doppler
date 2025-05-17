ExUnit.configure(formatters: [JUnitFormatter, ExUnit.CLIFormatter])
{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.start(timeout: 2 * 60 * 1000)

defmodule Helper do
  @moduledoc false
end
