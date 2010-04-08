# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

user = User.create :name => 'Thomas Ingram', :email => 'thomas@ravinggenius.com'

n = TextBlock.new :data => 'Welcome to the ScratchPad!'
n.title = 'Welcome'
n.user = user
n.save

=begin

l = List.new
l.user = user
l.title = 'Check out this mighty List!'
l.items << 'Make this work'
l.save

Table.create :user => user, :title => 'Impressive dataset', :caption => '(It\'s not really that impressive)', :data => '"One","Two"'

n = Page.create :user => user, :title => 'About Us', :slug => 'about'
n.nodes << Text.first
n.nodes << List.first
n.save

n = Comment.create :user => user, :title => 'My Awesome Comment'
n.nodes << Text.first
n.nodes << Table.first
n.save

=end
