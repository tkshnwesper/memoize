require "./spec_helper"

module TestMemoize
  extend self

  CALLS = [] of Int32

  Memoize.memoize add_two, NamedTuple(n: Int32), Int32 do
    CALLS << n
    n + 2
  end
end

describe Memoize do
  it "runs memoized method only once for same parameters" do
    TestMemoize.add_two(6).should eq 8
    TestMemoize.add_two(6).should eq 8
    TestMemoize.add_two(6).should eq 8
    TestMemoize::CALLS.should eq [6]
  end
end
