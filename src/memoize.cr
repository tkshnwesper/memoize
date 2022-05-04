# Module to create memoized functions using macros.
#
# ## How it works
#
# ```
# Memoize.memoize get_number, NamedTuple(n: Int32), String do
#   puts "Computed"
#   n.to_s
# end
# ```
#
# The above usage will generate
#
# ```
# CACHE_get_number = {} of {Int32} => String
#
# def _get_number(n : Int32) : String
#   puts "Computed"
#   n.to_s
# end
#
# def get_number(n : Int32) : String
#   if CACHE_get_number.has_key?({n})
#     CACHE_get_number[{n}]
#   else
#     CACHE_get_number[{n}] = _get_number(n)
#   end
# end
# ```
module Memoize
  VERSION = "1.0.0"

  # Macro which creates a memoized function without any space bounds (infinitely large cache).
  #
  # ```
  # Memoize.memoize add_two, NamedTuple(n: Int32), Int32 do
  #   puts "Computed"
  #   n + 2
  # end
  #
  # add_two(6) # Prints "Computed" and returns 6
  # add_two(6) # returns 6
  # add_two(6) # returns 6
  # ```
  macro memoize(method_name, param_tuple, return_type, &block)
    {% param_named_tuple = param_tuple.named_args %}
    {% param_list = param_named_tuple.keys %}
    {% type_list = param_named_tuple.values %}
    {% def_param_list = param_named_tuple.map { |param, type| "#{param} : #{type}" }.join(", ").id %}

    CACHE_{{ method_name }} = {} of {{ *type_list }} => {{ return_type }}

    def _{{ method_name }}({{ def_param_list }}) : {{ return_type }}
        {{ yield }}
    end

    def {{ method_name }}({{ def_param_list }}) : {{ return_type }}
        if CACHE_{{ method_name }}.has_key?({{ *param_list }})
            CACHE_{{ method_name }}[{{ *param_list }}]
        else
            CACHE_{{ method_name }}[{{ *param_list }}] = _{{ method_name }}({{ *param_list }})
        end
    end
  end
end
