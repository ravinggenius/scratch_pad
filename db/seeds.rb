# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

user = User.create :name => 'Thomas Ingram', :email => 'thomas@ravinggenius.com'

=begin

List.create :user => user, :title => 'Check out this mighty List!', :items => [ 'Make this work' ]

Table.create :user => user, :title => 'Impressive dataset', :caption => '(It\'s not really that impressive)', :data => '"One","Two"'

Text.create :user => user, :title => 'Welcome', :data => 'Welcome to Raving Genius\' ScratchPad!'

n = Page.create :user => user, :title => 'About Us', :slug => 'about'
n.nodes << Text.first
n.nodes << List.first
n.save

n = Comment.create :user => user, :title => 'My Awesome Comment'
n.nodes << Text.first
n.nodes << Table.first
n.save

=end
