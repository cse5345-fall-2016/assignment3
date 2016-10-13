defmodule Ex03 do

    def pmap(collection, process_count, function) do
    	count = Enum.count(collection)/process_count 
        new_count = Float.ceil(count)
        final_count = round(new_count)

        list = Enum.chunk(collection, final_count, final_count,[])
        
        new_list = Enum.map(list, fn x -> Task.async(fn -> Enum.map(x, function) end) end) 
        
        final_list = Enum.map(new_list, fn x -> Task.await(x) end)
        
        Enum.concat(final_list)
         
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