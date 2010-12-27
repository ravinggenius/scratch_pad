owner = User.anonymous
filter = FilterGroup.create :name => 'Blank', :filters => [DoNothing]

n = List::Model.new :title => 'Check out this mighty List!', :filter_group => filter
n.items << 'Make this work'
n.creator = owner
n.save

n = List::Model.new :title => 'Another List!', :filter_group => filter, :items => [ 'Line one', 'Line two' ]
n.creator = owner
n.save

n = TextBlock::Model.new :title => 'Welcome', :filter_group => filter, :data => 'Welcome to your new ScratchPad!'
n.creator = owner
n.save

n = Table::Model.new :title => 'Even better dataset', :filter_group => filter, :caption => 'That\'s what *she* said', :data => [
  [ 'a', 'b', 'c' ],
  [ '1', '2', '3' ],
  [ '4', '5', '6' ]
]
n.creator = owner
n.save

n = TextBlock::Model.new :title => 'Stub', :filter_group => filter, :data => 'Static pages with human-friendly URLs are very cool.'
n.creator = owner
n.save

n = Post::Model.new :title => 'Blog Post', :filter_group => filter, :is_published => true
n.children << TextBlock::Model.all.last
n.children << TextBlock::Model.first
n.children << Table::Model.first
n.creator = owner
n.save

n = Post::Model.new :title => 'Not About Us', :filter_group => filter, :is_published => true
n.children << TextBlock::Model.first
n.children << Table::Model.first
n.creator = owner
n.save

n = Page::Model.new :title => 'About Us', :filter_group => filter, :is_published => true, :slug => 'about'
n.children << TextBlock::Model.first
n.children << List::Model.first
n.creator = owner
n.save
