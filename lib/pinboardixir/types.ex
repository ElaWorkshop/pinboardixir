defmodule Pinboardixir.Types do
  @moduledoc false

  @typedoc """
  Converted string result from some operations to `:ok` or `{:error, reason}`.
  """
  @type result :: :ok | {:error, String.t}

  @typedoc """
  Refer to [Pinboard's official documentation](https://pinboard.in/api/) for explaination and example. Note:

  - All values should be String, booleans are represented by "yes" or "no"
  - To represent multiple tags, seperate them by space or `,`
  - Invalid keys will be filtered out before sending the request
  """
  @type options :: [{atom, String.t}]

end
