# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

DataMapper.auto_migrate!

user = User.create :name => 'Thomas Ingram', :email => 'thomas@ravinggenius.com'

n = TextBlock.new :data => 'Welcome to your new ScratchPad!'
n.title = 'Welcome'
n.user = user
n.save

n = Table.new :caption => 'That\'s what she said', :data => '"One","Two"'
n.title = 'Impressive dataset'
n.user = user
n.save

=begin

l = List.new
l.items << 'Make this work'
l.title = 'Check out this mighty List!'
l.user = user
l.save

n = Page.new :slug => 'about'
n.nodes << Text.first
n.nodes << List.first
n.title = 'About Us'
n.user = user
n.save

n = Comment.new
n.nodes << Text.first
n.nodes << Table.first
n.title = 'My Awesome Comment'
n.user = user
n.save

=end
