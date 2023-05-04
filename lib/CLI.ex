defmodule Tl.CLI do

  def main([]), do: main(["help"])

  def main(["help"]) do
    IO.puts("""
    - new cap <name>
    - cap <quick content>
    - filename
      - prepend <filenames>
        - date <filenames>
        - datetime <filenames>
    - file
      - prepend <filename> <content>
      - append <filename> <content>
    - jrnl
      - lock
      - unlock
      - new <name>
      - refresh
      - archive-done
    - rm <filenames>
    """)
  end


  def main(["rm" | rest]) do
    Tl.Rm.call(rest)
  end

  def main(["filename" | rest]) do
    Tl.Filename.call(rest)
  end

  def main(["file" | rest]) do
    Tl.File.call(rest)
  end

  def main(["jrnl" | rest]) do
    Tl.Jrnl.call(rest)
  end

  def main(["workup", val]) do
    {weight, _} = Float.parse(val)
    first = weight * 0.60
    second = weight * 0.80

    IO.puts("#{val}(#{side(weight)})  (#{side(first)}, #{side(second)})")
  end

  def side(weight) do
    (weight - 45) / 2
  end
end
