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

CACHE_get_number = {} of {Int32} => String

def _get_number(n : Int32) : String
  puts "Computed"
  n.to_s
end

def get_number(n : Int32) : String
  if CACHE_get_number.has_key?({n})
    CACHE_get_number[{n}]
  else
    CACHE_get_number[{n}] = _get_number(n)
  end
end

get_number 10
