require "./spec_helper"

class TestMemoizeMethod
  getter calls

  def initialize
    @calls = [] of Int32
  end

  Memoize.memoize add_two, NamedTuple(n: Int32), Int32 do
    @calls << n
    n + 2
  end
end

class TestMemoizeOnlyMethod
  getter calls

  def initialize
    @calls = 0
  end

  Memoize.memoize_only search, NamedTuple(db: Object), NamedTuple(query: String), String do
    @calls += 1
    query + query
  end
end

describe Memoize do
  it "runs memoized method only once for same parameters" do
    tm = TestMemoizeMethod.new
    tm.add_two(6).should eq 8
    tm.add_two(6).should eq 8
    tm.add_two(6).should eq 8
    tm.calls.should eq [6]
  end

  it "memoizes method only for certain parameters" do
    tmo = TestMemoizeOnlyMethod.new
    tmo.search(1, "hi")
    tmo.search(2, "hi")
    tmo.calls.should eq 1
  end
end
