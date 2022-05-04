crystal_doc_search_index_callback({"repository_name":"memoize","body":"# memoize\n\nMacros for memoizing functions.\n\n## Installation\n\n1. Add the dependency to your `shard.yml`:\n\n   ```yaml\n   dependencies:\n     memoize:\n       github: tkshnwesper/memoize\n   ```\n\n2. Run `shards install`\n\n## Usage\n\n```crystal\nrequire \"memoize\"\n\nMemoize.memoize add_two, NamedTuple(n: Int32), Int32 do\n  puts \"Computed\"\n  n + 2\nend\n\nadd_two(5)  # Prints \"Computed\"\nadd_two(5)\nadd_two(5)\n```\n\n## Contributing\n\n1. Fork it (<https://github.com/tkshnwesper/memoize/fork>)\n2. Create your feature branch (`git checkout -b my-new-feature`)\n3. Commit your changes (`git commit -am 'Add some feature'`)\n4. Push to the branch (`git push origin my-new-feature`)\n5. Create a new Pull Request\n\n## Contributors\n\n- [tkshnwesper](https://github.com/tkshnwesper) - creator and maintainer\n","program":{"html_id":"memoize/toplevel","path":"toplevel.html","kind":"module","full_name":"Top Level Namespace","name":"Top Level Namespace","abstract":false,"locations":[],"repository_name":"memoize","program":true,"enum":false,"alias":false,"const":false,"types":[{"html_id":"memoize/Memoize","path":"Memoize.html","kind":"module","full_name":"Memoize","name":"Memoize","abstract":false,"locations":[{"filename":"src/memoize.cr","line_number":30,"url":"https://github.com/tkshnwesper/memoize/blob/1.0.0/src/memoize.cr#L30"}],"repository_name":"memoize","program":false,"enum":false,"alias":false,"const":false,"constants":[{"id":"VERSION","name":"VERSION","value":"\"1.0.0\""}],"doc":"Module to create memoized functions using macros.\n\n## How it works\n\n```\nMemoize.memoize get_number, NamedTuple(n: Int32), String do\n  puts \"Computed\"\n  n.to_s\nend\n```\n\nThe above usage will generate\n\n```\nCACHE_get_number = {} of {Int32} => String\n\ndef _get_number(n : Int32) : String\n  puts \"Computed\"\n  n.to_s\nend\n\ndef get_number(n : Int32) : String\n  if CACHE_get_number.has_key?({n})\n    CACHE_get_number[{n}]\n  else\n    CACHE_get_number[{n}] = _get_number(n)\n  end\nend\n```","summary":"<p>Module to create memoized functions using macros.</p>","macros":[{"html_id":"memoize(method_name,param_tuple,return_type,&block)-macro","name":"memoize","doc":"Macro which creates a memoized function without any space bounds (infinitely large cache).\n\n```\nMemoize.memoize add_two, NamedTuple(n: Int32), Int32 do\n  puts \"Computed\"\n  n + 2\nend\n\nadd_two(6) # Prints \"Computed\"\nadd_two(6)\nadd_two(6)\n```","summary":"<p>Macro which creates a memoized function without any space bounds (infinitely large cache).</p>","abstract":false,"args":[{"name":"method_name","external_name":"method_name","restriction":""},{"name":"param_tuple","external_name":"param_tuple","restriction":""},{"name":"return_type","external_name":"return_type","restriction":""}],"args_string":"(method_name, param_tuple, return_type, &block)","args_html":"(method_name, param_tuple, return_type, &block)","location":{"filename":"src/memoize.cr","line_number":45,"url":"https://github.com/tkshnwesper/memoize/blob/1.0.0/src/memoize.cr#L45"},"def":{"name":"memoize","args":[{"name":"method_name","external_name":"method_name","restriction":""},{"name":"param_tuple","external_name":"param_tuple","restriction":""},{"name":"return_type","external_name":"return_type","restriction":""}],"block_arg":{"name":"block","external_name":"block","restriction":""},"visibility":"Public","body":"    \n{% param_named_tuple = param_tuple.named_args %}\n\n    \n{% param_list = param_named_tuple.keys %}\n\n    \n{% type_list = param_named_tuple.values %}\n\n    \n{% def_param_list = (param_named_tuple.map do |param, type|\n  \"#{param} : #{type}\"\nend.join(\", \")).id %}\n\n\n    CACHE_\n{{ method_name }}\n = \n{} of \n{{ *type_list }}\n => \n{{ return_type }}\n\n\n    def _\n{{ method_name }}\n(\n{{ def_param_list }}\n) : \n{{ return_type }}\n\n        \n{{ yield }}\n\n    \nend\n\n    def \n{{ method_name }}\n(\n{{ def_param_list }}\n) : \n{{ return_type }}\n\n        if CACHE_\n{{ method_name }}\n.has_key?(\n{{ *param_list }}\n)\n            CACHE_\n{{ method_name }}\n[\n{{ *param_list }}\n]\n        \nelse\n            CACHE_\n{{ method_name }}\n[\n{{ *param_list }}\n] = _\n{{ method_name }}\n(\n{{ *param_list }}\n)\n        \nend\n    \nend\n  \n"}}]}]}})