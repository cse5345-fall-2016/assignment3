# defmodule Scr do
#   def init do
#     Agent.start_link(fn -> 0 end, name: __MODULE__)
#   end
#   def add_num(n) do
#     Agent.update(__MODULE__, &(&1+n))
#     Agent.get(__MODULE__, &(&1))
#   end
#   def get_num do
#     Agent.get(__MODULE__, &(&1))
#   end
# end
collection = [4,5,6,8,7,9,6,4]
defmodule Sc do
  def pmap(collection, process_count) do
    div = round(Enum.count(collection) / process_count)
    Enum.chunk(collection, div, process_count)
  end
end
