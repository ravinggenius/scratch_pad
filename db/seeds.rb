filter_group = FilterGroup.first_or_new :name => 'Blank'
if filter_group.new?
  filter_group.filters << DoNothing
  filter_group.save
end

common = {
  :creator_id => User.anonymous.id,
  :filter_group_id => filter_group.id
}

n = List::Model.first_or_new common.merge(:title => 'Check out this mighty List!')
n.items << 'Make this work'
n.save if n.new?

n = List::Model.first_or_new common.merge(:title => 'Another List!', :items => [ 'Line one', 'Line two' ])
n.save if n.new?

n = TextBlock::Model.first_or_new common.merge(:title => 'Welcome', :data => 'Welcome to your new ScratchPad!')
n.save if n.new?

n = Table::Model.first_or_new common.merge(:title => 'Even better dataset')
if n.new?
  n.data = [
    [ 'a', 'b', 'c' ],
    [ '1', '2', '3' ],
    [ '4', '5', '6' ]
  ]
  n.save
end

n = TextBlock::Model.first_or_new common.merge(:title => 'Stub', :data => 'Static pages with human-friendly URLs are very cool.')
n.save if n.new?

n = Post::Model.first_or_new common.merge(:title => 'Blog Post', :state => :published)
n.children << TextBlock::Model.all.last
n.children << TextBlock::Model.first
n.children << Table::Model.first
n.save if n.new?

n = Post::Model.first_or_new common.merge(:title => 'Not About Us', :state => :published)
n.children << TextBlock::Model.first
n.children << Table::Model.first
n.save if n.new?

n = Page::Model.first_or_new common.merge(:title => 'About Us', :state => :published, :slug => 'about')
n.children << TextBlock::Model.first
n.children << List::Model.first
n.save if n.new?
