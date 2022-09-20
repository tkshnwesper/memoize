require "./spec_helper"

CALLS = [] of Int32

class TestMemoize
  Memoize.memoize add_two, NamedTuple(n: Int32), Int32 do
    CALLS << n
    n + 2
  end
end

describe Memoize do
  it "runs memoized method only once for same parameters" do
    tm = TestMemoize.new
    tm.add_two(6).should eq 8
    tm.add_two(6).should eq 8
    tm.add_two(6).should eq 8
    CALLS.should eq [6]
  end
end
