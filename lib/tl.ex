defmodule Tl do
  defdelegate log(text), to: Tl.Log
  defdelegate log(context, text), to: Tl.Log
end
