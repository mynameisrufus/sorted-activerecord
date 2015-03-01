# Sorted::Activerecord

[![Build Status](https://travis-ci.org/mynameisrufus/sorted-activerecord.svg?branch=master)](https://travis-ci.org/mynameisrufus/sorted-activerecord)

These helpers will let you sort large datasets over many pages (using
[will_paginate](https://github.com/mislav/will_paginate) or
[kaminari](https://github.com/amatsuda/kaminari)) without losing state.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sorted-activerecord'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sorted-activerecord

## Usage

The sorted scope takes two optional arguments, `sort` and `order`, they both
conform to the [AR query
interface](http://guides.rubyonrails.org/active_record_querying.html#ordering)
except that if you provide a string to the sort argument it expects a
`Sorted::URIQuery` encoded string:

```ruby
@users = User.sorted(sort: 'created_asc!orders_count_asc', order: 'orders_count ASC, created_at DESC')
```

See https://github.com/mynameisrufus/sorted-actionview for a view helper to
generate the sort string or roll your own.

A `resorted` method is also available and works the same way as the `reorder`
method in Rails. It forces the order to be the one passed in:

```ruby
@users = User.order(:id).sorted(order: 'name DESC').resorted(sort: params[:sort], order: 'email ASC')
```

If you want to prevent people creating 500s by messing with the sort url string
you can use a white list:

```ruby
@users = User.sorted(sort: 'created_asc!explode_me_asc', whitelist: %w(created_at))
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/sorted-activerecord/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
