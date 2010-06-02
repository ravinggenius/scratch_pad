# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

groups = {
  :locked => Group.create(:access_code => 0, :code => :locked, :name => 'Locked Users'),
  :editor => Group.create(:access_code => 1, :code => :editor, :name => 'Editors'),
  :author => Group.create(:access_code => 2, :code => :author, :name => 'Authors'),
  :admin => Group.create(:access_code => 4, :code => :admin, :name => 'Administrators'),
  :root => Group.create(:access_code => 8, :code => :root, :name => 'SuperAdmins')
}

anon = User.new :username => 'anon', :name => 'Anonymous', :email => 'anonymous@example.com'
anon.password = anon.password_confirmation = '12345678'
anon.groups << groups[:locked]
anon.save

root = User.new :username => 'root', :name => 'Administrator', :email => 'root@example.com'
root.password = root.password_confirmation = '12345678'
root.groups << groups[:root]
root.save

n = List.new :title => 'Check out this mighty List!' #, :creator => root
n.items << 'Make this work'
n.creator = root
n.save

n = List.new :title => 'Another List!', :items => [ 'Line one', 'Line two' ]
n.save

n = TextBlock.new :title => 'Welcome', :data => 'Welcome to your new ScratchPad!'
n.save

n = Table.new :title => 'Even better dataset', :caption => 'That\'s what *she* said', :data => [
  [ 'a', 'b', 'c' ],
  [ '1', '2', '3' ],
  [ '4', '5', '6' ]
]
n.save

n = TextBlock.new :title => 'Stub', :data => 'Static pages with human-friendly URLs are very cool.'
n.save

n = Post.new :title => 'Blog Post', :is_published => true
n.children << TextBlock.all.last
n.children << TextBlock.first
n.children << Table.first
n.save

n = Post.new :title => 'Not About Us', :is_published => true
n.children << TextBlock.first
n.children << Table.first
n.save

n = Page.new :title => 'About Us', :is_published => true, :slug => 'about'
n.children << TextBlock.first
n.children << List.first
n.save

=begin

n = Comment.new :title => 'My Awesome Comment'
n.children << TextBlock.first
n.children << Table.first
n.save

=end
