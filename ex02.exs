defmodule Ex02 do

	def new_counter(value) do
		Agent.start( fn -> value end)
	end
	
	def next_value({:ok, count}) do
		value = Agent.get(count, &(&1))
		Agent.update(count, &(&1+1))
		value
	end
	
	def new_global_counter do
		Agent.start( fn -> 0 end, name: 	Counter)
		
	end
	
	def global_next_value do
		value = Agent.get(Counter, &(&1))
		Agent.update(Counter, &(&1+1))
		value
	end
	

end

ExUnit.start()

defmodule Test do
  use ExUnit.Case

	test "counter using an agent" do
		{ :ok, counter } = Agent.start( fn -> 0 end)
   
    	value   = Agent.get(counter, &(&1))
  		Agent.update(counter, &(&1+1))
    	assert value == 0
   
    	value   = Agent.get(counter, &(&1))
  		Agent.update(counter, &(&1+1))
    	assert value == 1
   end


   test "higher level API interface" do
     count = Ex02.new_counter(5)
     assert  Ex02.next_value(count) == 5
     assert  Ex02.next_value(count) == 6
   end

   test "global counter" do
     Ex02.new_global_counter
     assert Ex02.global_next_value == 0
     assert Ex02.global_next_value == 1
     assert Ex02.global_next_value == 2
   end
end