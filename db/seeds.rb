def owner
  @o ||= User.first(:username => 'root') or @o ||= User.first(:username => 'anon')
end

n = List.new :title => 'Check out this mighty List!'
n.items << 'Make this work'
n.creator = owner
n.save

n = List.new :title => 'Another List!', :items => [ 'Line one', 'Line two' ]
n.creator = owner
n.save

n = TextBlock.new :title => 'Welcome', :data => 'Welcome to your new ScratchPad!'
n.creator = owner
n.save

n = Table.new :title => 'Even better dataset', :caption => 'That\'s what *she* said', :data => [
  [ 'a', 'b', 'c' ],
  [ '1', '2', '3' ],
  [ '4', '5', '6' ]
]
n.creator = owner
n.save

n = TextBlock.new :title => 'Stub', :data => 'Static pages with human-friendly URLs are very cool.'
n.creator = owner
n.save

n = Post.new :title => 'Blog Post', :is_published => true
n.children << TextBlock.all.last
n.children << TextBlock.first
n.children << Table.first
n.creator = owner
n.save

n = Post.new :title => 'Not About Us', :is_published => true
n.children << TextBlock.first
n.children << Table.first
n.creator = owner
n.save

n = Page.new :title => 'About Us', :is_published => true, :slug => 'about'
n.children << TextBlock.first
n.children << List.first
n.creator = owner
n.save

=begin

n = Comment.new :title => 'My Awesome Comment'
n.children << TextBlock.first
n.children << Table.first
n.creator = owner
n.save

=end
