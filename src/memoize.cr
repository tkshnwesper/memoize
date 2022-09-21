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
# @CACHE_get_number = {} of {Int32} => String
#
# def _get_number(n : Int32) : String
#   puts "Computed"
#   n.to_s
# end
#
# def get_number(n : Int32) : String
#   if @CACHE_get_number.has_key?({n})
#     @CACHE_get_number[{n}]
#   else
#     @CACHE_get_number[{n}] = _get_number(n)
#   end
# end
# ```
module Memoize
  VERSION = "1.2.0"

  # Macro which creates a memoized function without any space bounds (infinitely large cache).
  #
  # ```
  # Memoize.memoize add_two, NamedTuple(n: Int32), Int32 do
  #   puts "Computed"
  #   n + 2
  # end
  #
  # add_two(5) # Prints "Computed" and returns 7
  # add_two(5) # returns 7
  # add_two(5) # returns 7
  # ```
  macro memoize_method(method_name, param_tuple, return_type, &block)
    {% param_named_tuple = param_tuple.named_args %}
    {% param_list = param_named_tuple.keys %}
    {% type_list = param_named_tuple.values %}
    {% def_param_list = param_named_tuple.map { |param, type| "#{param} : #{type}" }.join(", ").id %}

    @CACHE_{{ method_name }} = {} of {{ *type_list }} => {{ return_type }}

    def _{{ method_name }}({{ def_param_list }}) : {{ return_type }}
        {{ yield }}
    end

    def {{ method_name }}({{ def_param_list }}) : {{ return_type }}
        if @CACHE_{{ method_name }}.has_key?({{ *param_list }})
            @CACHE_{{ method_name }}[{{ *param_list }}]
        else
            @CACHE_{{ method_name }}[{{ *param_list }}] = _{{ method_name }}({{ *param_list }})
        end
    end
  end

  # Like `memoize_method` but can be used in any scope (class, module, global).
  # If using in class, the memoization will happen at class level meaning, memoized objects can
  # be accessed between different instances of the class.
  macro memoize(method_name, param_tuple, return_type, &block)
    {% param_named_tuple = param_tuple.named_args %}
    {% param_list = param_named_tuple.keys %}
    {% type_list = param_named_tuple.values %}
    {% def_param_list = param_named_tuple.map { |param, type| "#{param} : #{type}" }.join(", ").id %}

    @CACHE_{{ method_name }} = {} of {{ *type_list }} => {{ return_type }}

    def _{{ method_name }}({{ def_param_list }}) : {{ return_type }}
        {{ yield }}
    end

    def {{ method_name }}({{ def_param_list }}) : {{ return_type }}
        if @CACHE_{{ method_name }}.has_key?({{ *param_list }})
            @CACHE_{{ method_name }}[{{ *param_list }}]
        else
            @CACHE_{{ method_name }}[{{ *param_list }}] = _{{ method_name }}({{ *param_list }})
        end
    end
  end

  # Only memoizes certain parameters of a method.
  # Useful when certain parameters do not have equals and hash implemented,
  # but memoization is still necessary on the other parameters.
  # `rest_tuple` should be a `NamedTuple` containing parameters that should **not** be memoized.
  # `only_tuple` should be a `NamedTuple` containing parameters that need to be memoized.
  macro memoize_only_method(method_name, rest_tuple, only_tuple, return_type, &block)
    {% rest_named_tuple = rest_tuple.named_args %}
    {% rest_param_list = rest_named_tuple.keys %}
    {% rest_def_param_list = rest_named_tuple.map { |param, type| "#{param} : #{type}" }.join(", ").id %}

    {% only_named_tuple = only_tuple.named_args %}
    {% only_param_list = only_named_tuple.keys %}
    {% only_type_list = only_named_tuple.values %}
    {% only_def_param_list = only_named_tuple.map { |param, type| "#{param} : #{type}" }.join(", ").id %}

    @CACHE_{{ method_name }} = {} of {{ *only_type_list }} => {{ return_type }}

    def _{{ method_name }}({{ rest_def_param_list }}, {{ only_def_param_list }}) : {{ return_type }}
        {{ yield }}
    end

    def {{ method_name }}({{ rest_def_param_list }}, {{ only_def_param_list }}) : {{ return_type }}
        if @CACHE_{{ method_name }}.has_key?({{ *only_param_list }})
            @CACHE_{{ method_name }}[{{ *only_param_list }}]
        else
            @CACHE_{{ method_name }}[{{ *only_param_list }}] = _{{ method_name }}(
              {{ *rest_param_list }}, {{ *only_param_list }})
        end
    end
  end

  # Like `memoize_only_method` but can be used in any scope (module, class, global).
  # If using in class, the memoization will happen at class level meaning, memoized objects can
  # be accessed between different instances of the class.
  macro memoize_only(method_name, rest_tuple, only_tuple, return_type, &block)
    {% rest_named_tuple = rest_tuple.named_args %}
    {% rest_param_list = rest_named_tuple.keys %}
    {% rest_def_param_list = rest_named_tuple.map { |param, type| "#{param} : #{type}" }.join(", ").id %}

    {% only_named_tuple = only_tuple.named_args %}
    {% only_param_list = only_named_tuple.keys %}
    {% only_type_list = only_named_tuple.values %}
    {% only_def_param_list = only_named_tuple.map { |param, type| "#{param} : #{type}" }.join(", ").id %}

    CACHE_{{ method_name }} = {} of {{ *only_type_list }} => {{ return_type }}

    def _{{ method_name }}({{ rest_def_param_list }}, {{ only_def_param_list }}) : {{ return_type }}
        {{ yield }}
    end

    def {{ method_name }}({{ rest_def_param_list }}, {{ only_def_param_list }}) : {{ return_type }}
        if CACHE_{{ method_name }}.has_key?({{ *only_param_list }})
            CACHE_{{ method_name }}[{{ *only_param_list }}]
        else
            CACHE_{{ method_name }}[{{ *only_param_list }}] = _{{ method_name }}(
              {{ *rest_param_list }}, {{ *only_param_list }})
        end
    end
  end
end
