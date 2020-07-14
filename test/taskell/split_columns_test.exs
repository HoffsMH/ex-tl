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

  test "column_filename/1" do
    Application.put_env(:tl, :taskell_split_dir, "/test_dir")
    result = Tl.Taskell.SplitColumns.column_filename("test_column")

    assert result === "/test_dir/test_column.md"
  end
end
