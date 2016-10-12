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
collection = [4,5,6,8,7,9,6,]
defmodule Sc do
  def pmap(collection, process_count, function) do
    div = round(Enum.count(collection) / process_count)
    me = self
    list = Enum.chunk(collection, div, div, [])
    |> Enum.map(fn(elem) ->
      spawn fn -> (send me, {self, (Enum.map(elem, &(&1+1))) }) end
    end)
    |> Enum.map(fn(pid) ->
      receive do
        {^pid, result} -> result
      end
    end)
    Enum.concat(list)
  end
end
