# Capn
Capn is a crunchier approach to serialization.

It's designed to circumvent most of Rails' magic to speed up serialization.
To acheive this, it uses the ability of Postgresql to build JSON itself, a
technique inspired by [dockyard/postgres\_ext-serializers][dockyard-gem],
but which I expanded and improved upon.

Their library requires you to implement all computed fields in SQL, but Capn
allows you to use Ruby instead.  Capn also takes a different approach than
the ActiveModel::Serializers API.

[dockyard-gem]: https://github.com/dockyard/postgres_ext-serializers

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capn'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capn

## Usage
First, you build a serializer class.  Remember that you're dealing with the
actual table, not the model you've built around it.

So, let's take a look at a somewhat contrived example media player
application, and start by building the tables it needs:

```ruby
create_table :songs do
  t.string :title
  t.string :genres
  t.integer :play_count
  t.integer :artist
  t.integer :minutes
  t.integer :seconds
end
create_table :artists do
  t.string :name
end
```

Okay, now let's make a serializer for the so, to demonstrate Capn's power:

```ruby
# app/serializers/song_serializer.rb
class SongSerializer < Capn::Serializer
  # Name of the object type in the serialized output
  name :song

  # Direct mapping of fields
  fields :title, :genres

  # Serializes the "play_count" column into the "plays" field
  field :plays => :play_count

  # Creates a computed field named "display_time", which uses the "minutes"
  # and "seconds" columns to build a new field.
  field :display_time, [:minutes, :seconds] do
    minutes + ':' + seconds
  end

  # has_one/belongs_to are the same thing and work for either.
  # include: true makes the associated object get sideloaded
  has_one :artist, include: true
end
```

Now that we have a Serializer for the Song model, let's set this as the
default serializer for that model:

```ruby
# app/models/song.rb
class Song < ActiveRecord::Base
  extend Capn::Serializeable::ActiveRecord
  default_serializer SongSerializer

  belongs_to :artist
end
```

Capn exposes the serializer via class methods on the model:

```ruby
Song.all.serialize
# => SongSerializer
```

And then we can just call `#to_json` on it to get the JSON string. `#as_json`
works too, but forces Capn to parse the JSON only for it to be reserialized.

## Contributing

1. Fork it ( https://github.com/nuckchorris/capn/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
