defmodule Pinboardixir.Types do
  @moduledoc false

  @typedoc """
  Converted string result from some operations to `:ok` or `{:error, reason}`.
  """
  @type result :: :ok | {:error, String.t}
end
