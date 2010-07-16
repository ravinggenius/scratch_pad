## Dependencies

### System
* git
* mongodb
  * optional bson_ext
* ruby (works in 1.8.7, should work (not tested) in 1.9.*)

### RubyGems
* rails 3 beta (technically you should not have to install this system-wide, but it will make things easier if you do: `[sudo] gem install rails --pre`)
* bundler (handles installing everything else)

## Getting Started

1. clone the project
  * type `cd ~/code`
  * type `git clone -o github git://github.com/ravinggenius/scratch_pad.git`
    * this will create a directory called scratch_pad (feel free to rename it)
2. change into the project directory
3. type `bundle install`
  * this will make sure every dependency in Gemfile is resolved and available
4. start hacking!
  * if you have rails 3 installed system-wide, you can run `rails` to see available commands, otherwise use `script/rails`

A nice looking introduction to Ruby and MongoDB can be found on GitHub: http://github.com/chicagoruby/MongoDB_Koans

To run tests for custom extensions, use `RAILS_ENV=test rake test:custom`. Currently there is no way to avoid manually setting the environment

## Coding Standards

* tests are good and should remain passing to the extent possible
* 2 spaces indents
  * technically ruby doesn't care about indentation or whether spaces or tabs are used
    * however 2 space indents are the de facto standard that nearly every rubyist on the planet follows
  * sass requires space-based indentation (no tabs!), and 2 spaces seems to be the norm
  * scss doesn't care about about indentation (it uses { and }), but indenting really helps with readability
* style selectors should be one per line
  * (optionally) unless there are many selectors for the declared style
* ruby def statements should wrap arguments with parentheses
  * parentheses should be left off if no arguments are accepted

## Features

* every piece of content is a node. every node may have arbitrary sub-nodes
  * some nodes are meant to be child nodes, for instance table. others are meant to be a collection of nodes, for instance post

## To Do

* finish options/settings and user preferences
* make users and groups easily swappable for another user system, in part or in whole
* default theme should look better
* themes and node extensions should have a manifest (probably yaml) to specify their javascript dependencies

## Wish List

* move styles and themes into the database to facilitate online editing by a website administrator