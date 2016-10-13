defmodule Ex01 do
  
  def counter(value \\ 0) do
	receive do
		{:next, from} -> send from, {:next_is, value}
		counter(value+1)
	end
  end
end

ExUnit.start()

defmodule Test do
  use ExUnit.Case

	test "basic message interface" do
		count = spawn Ex01, :counter, []
		send count, { :next, self }
		receive do
			{:next_is, value} ->
         	assert value == 0
		end
   
		send count, { :next, self }
		receive do
			{ :next_is, value } ->
         	assert value == 1
    	end
	
   	end

	def new_counter(a) do
		count = spawn Ex01, :counter, [a]
  	end
  
  
  	def next_value(count) do
		send count, {:next , self}
		get_response
  	end
  
	defp get_response do
  		receive do
  			{:next_is, value} -> value
  		end
  	end
   test "higher level API interface" do
     count = new_counter(5)
     assert  next_value(count) == 5
     assert  next_value(count) == 6
   end

end