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

Using the `sorted` method with the optional default order argument:

```ruby
@users = User.sorted(params[:sort], "email ASC").page(params[:page])
```

A `resorted` method is also available and works the same way as the `reorder` method in Rails.
It forces the order to be the one passed in:

```ruby
@users = User.order(:id).sorted(nil, 'name DESC').resorted(params[:sort], 'email ASC')
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/sorted-activerecord/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
