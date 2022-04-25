# memoize

Macros for memoizing functions.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     memoize:
       github: tkshnwesper/memoize
   ```

2. Run `shards install`

## Usage

```crystal
require "memoize"

Memoize.memoize add_two, NamedTuple(n: Int32), Int32 do
  puts "Computed"
  n + 2
end

add_two(5)  # Prints "Computed"
add_two(5)
add_two(5)
```

## Developing

To generate docs, run

```shell
crystal docs --source-refname=<tag>
```

## Contributing

1. Fork it (<https://github.com/tkshnwesper/memoize/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [tkshnwesper](https://github.com/tkshnwesper) - creator and maintainer
