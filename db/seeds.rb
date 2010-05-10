# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

anon = User.new :username => 'anon', :name => 'Anonymous', :email => 'anonymous@example.com', :position => 0
anon.password = anon.password_confirmation = '12345678'
anon.save

=begin

n = List.new
n.items << 'Make this work'
n.title = 'Check out this mighty List!'
n.user = user
n.save

n = List.new
n.items = [ 'Line one', 'Line two' ]
n.title = 'Another List!'
n.user = user
n.save

n = TextBlock.new :data => 'Welcome to your new ScratchPad!'
n.title = 'Welcome'
n.user = user
n.save

n = Table.new :caption => 'That\'s what *she* said', :data => '"_One_","Two"'
n.title = 'Impressive dataset'
n.user = user
n.save

n = Table.new :caption => 'That\'s what *she* said (again)'
n.data = [
  [ 'a', 'b', 'c' ],
  [ '1', '2', '3' ],
  [ '4', '5', '6' ]
]
n.title = 'Even better dataset'
n.user = user
n.save

n = TextBlock.new :data => 'Static pages with human-friendly URLs are very cool.'
n.title = 'Stub'
n.user = user
n.save

n = Post.new
n.nodes << TextBlock.last
n.nodes << TextBlock.first
n.nodes << Table.first
n.title = 'Static Page'
n.user = user
n.save

n = Post.new
n.nodes << TextBlock.first
n.nodes << Table.first
n.title = 'About Us'
n.user = user
n.save

n = Page.new :slug => 'about'
n.nodes << TextBlock.first
n.nodes << List.first
n.title = 'About Us'
n.user = user
n.save

n = Comment.new
n.nodes << TextBlock.first
n.nodes << Table.first
n.title = 'My Awesome Comment'
n.user = user
n.save

=end
