require 'minitest/autorun'

class Array
  def where(input_hash)
    new_array = []
    self.each do |hash|
      # if hash has data that matches input_hash, then add to new_array
      # if hash.merge(input_hash) == hash

      # --------------------------
      # match = true
      # inner loop through the input_hash  - input_hash.each do |key, value| 
      # check whether hash[key] == value (((regex logix would go here - hash[key] =~ value)))
      # if false, match = false
      # if we get to the end, do this:
      match = true 
      input_hash.each do |key, value|
        if value.class == Regexp
          match = false if hash[key] !~ value
        else
          match = false if hash[key] != value
        end
      end
      new_array << hash if match
    end
    return new_array
  end
end

class WhereTest < Minitest::Test
  def setup
    @boris   = {:name => 'Boris The Blade', :quote => "Heavy is good. Heavy is reliable. If it doesn't work you can always hit them.", :title => 'Snatch', :rank => 4}
    @charles = {:name => 'Charles De Mar', :quote => 'Go that way, really fast. If something gets in your way, turn.', :title => 'Better Off Dead', :rank => 3}
    @wolf    = {:name => 'The Wolf', :quote => 'I think fast, I talk fast and I need you guys to act fast if you wanna get out of this', :title => 'Pulp Fiction', :rank => 4}
    @glen    = {:name => 'Glengarry Glen Ross', :quote => "Put. That coffee. Down. Coffee is for closers only.",  :title => "Blake", :rank => 5}

    @fixtures = [@boris, @charles, @wolf, @glen]
  end

  def test_where_with_exact_match
    assert_equal [@wolf], @fixtures.where(:name => 'The Wolf')
  end

  def test_where_with_partial_match
    assert_equal [@charles, @glen], @fixtures.where(:title => /^B.*/)
  end

  def test_where_with_mutliple_exact_results
    assert_equal [@boris, @wolf], @fixtures.where(:rank => 4)
  end

  def test_with_with_multiple_criteria
    assert_equal [@wolf], @fixtures.where(:rank => 4, :quote => /get/)
  end

  def test_with_chain_calls
    assert_equal [@charles], @fixtures.where(:quote => /if/i).where(:rank => 3)
  end
end
