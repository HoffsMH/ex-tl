defmodule Tl.Taskell.SplitColumnsTest do
  use ExUnit.Case

  setup_all do
    defmodule Tl.FileStub do
      def read(_) do
        """
        ## Hi
        - ok

        ## What
        - ok
        """
      end
      def overwrite(_, _) do
      end
    end

    Application.put_env(:tl, :file_module, Tl.FileStub)
    {:ok, []}
  end

  test "call/0" do
    result = Tl.Taskell.SplitColumns.board_content()
    assert result == "hi"
  end
end
