#Finished in 1.2 seconds (0.04s on load, 1.2s on tests) | MacBook Pro | 16 GB 1600 MHz DDR3 | 2.3 GHz Intel Core i7
#1 out of 4 trials, the "pmap actually reduces time" test fails.

defmodule Ex03 do

  @moduledoc """

  `Enum.map` takes a collection, applies a function to each element in
  turn, and returns a list containing the result. It is an O(n)
  operation.

  Because there is no interaction between each calculation, we could
  process all elements of the original collection in parallel. If we
  had one processor for each element in the original collection, that
  would turn it into an O(1) operation.

  However, we don't have that many processors on our machines, so we
  have to compromise. If we have two processors, we could divide the
  map into two chunks, process each independently on its own
  processor, then combine the results.

  You might think this would halve the elapsed time, but the reality
  is that the initial chunking of the collection, and the eventual
  combining of the results both take time. As a result, the speed up
  will be less that a factor of two. If the work done in the mapping
  function is time consuming, then the speedup factor will be greater,
  as the overhead of chunking and combining will be relatively less.
  If the mapping function is trivial, then parallelizing the code will
  actually slow it down.

  Your mission is to implement a function

      pmap(collection, process_count, func)

  This will take the collection, split it into n chunks, where n is
  the process count, and then run each chunk through a regular map
  function, but with each map running in a separate process.

  Useful functions include `Enum.count/1`, `Enum.chunk/4` and
 `Enum.concat/1`.

  ------------------------------------------------------------------
  ## Marks available: 30

      Pragmatics
        4  does the code compile and run
        5	does it produce the correct results on any valid data

      Tested
      if tests are provided as part of the assignment:
        5	all pass

      Aesthetics
        4 is the program written in an idiomatic style that uses
          appropriate and effective language and library features
        4 is the program well laid out,  appropriately using indentation,
          blank lines, vertical alignment
        3 are names well chosen, descriptive, but not verbose

      Use of language and libraries
        5 elegant use of language features or libraries

  """

#Sources Used for pmap mentioned below:
#http://stackoverflow.com/questions/32589216/task-async-in-elixir-stream
# big_list
# |> Stream.map(&Task.async(Module, :do_something, [&1]))
# |> Stream.map(&Task.await(&1))
# |> Enum.filter filter_fun


#http://michal.muskala.eu/2015/08/06/parallel-downloads-in-elixir.html
# defp fetch_and_save_batch(committers) do
#   committers
#   |> Enum.map(&Task.async(fn -> fetch_and_save(&1) end))
#   |> Enum.map(&Task.await(&1, 10000))
# end

#http://milmazz.uno/article/2016/09/03/asynchronous-tasks-with-elixir/
# Enum.map(&Task.async(fn ->
#        generate_module_page(&1, output)
#      end))
#   |> Enum.map(&Task.await/1)


  def pmap(collection, process_count, function) do
    size_of_chunk = round(Enum.count(collection)/process_count)
    Enum.chunk(collection, size_of_chunk, size_of_chunk, [])
    |>  Enum.map(&(Task.async(fn -> Enum.map(&1, function) end)))
    |>  Enum.map(&(Task.await/1))
    |> Enum.concat
  end


end


ExUnit.start
defmodule TestEx03 do
  use ExUnit.Case
  import Ex03

  test "pmap with 1 process" do
    assert pmap(1..10, 1, &(&1+1)) == 2..11 |> Enum.into([])
  end

  test "pmap with 2 processes" do
    assert pmap(1..10, 2, &(&1+1)) == 2..11 |> Enum.into([])
  end

  test "pmap with 3 processes (doesn't evenly divide data)" do
    assert pmap(1..10, 3, &(&1+1)) == 2..11 |> Enum.into([])
  end

  # The following test will only pass if your computer has
  # multiple processors.
  test "pmap actually reduces time" do
    range = 1..1_000_000
    # random calculation to burn some cpu
    calc  = fn n -> :math.sin(n) + :math.sin(n/2) + :math.sin(n/4)  end

    { time1, result1 } = :timer.tc(fn -> pmap(range, 1, calc) end)
    { time2, result2 } = :timer.tc(fn -> pmap(range, 2, calc) end)

    assert result2 == result1
    assert time2 < time1 * 0.8
  end

end
