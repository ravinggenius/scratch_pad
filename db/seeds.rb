filter_group = FilterGroup.first_or_new :name => 'Blank'
if filter_group.new?
  filter_group.filters << Filters::DoNothing
  filter_group.save
end

common = {
  :creator_id => User.anonymous.id,
  :filter_group_id => filter_group.id
}

n = NodeExtensions::List::Model.first_or_new common.merge(:title => 'Check out this mighty List!')
n.items << 'Make this work'
n.save if n.new?

n = NodeExtensions::List::Model.first_or_new common.merge(:title => 'Another List!', :items => [ 'Line one', 'Line two' ])
n.save if n.new?

n = NodeExtensions::TextBlock::Model.first_or_new common.merge(:title => 'Welcome', :data => 'Welcome to your new ScratchPad!')
n.save if n.new?

n = NodeExtensions::Table::Model.first_or_new common.merge(:title => 'Even better dataset')
if n.new?
  n.data = [
    [ 'a', 'b', 'c' ],
    [ '1', '2', '3' ],
    [ '4', '5', '6' ]
  ]
  n.save
end

n = NodeExtensions::TextBlock::Model.first_or_new common.merge(:title => 'Stub', :data => 'Static pages with human-friendly URLs are very cool.')
n.save if n.new?

n = NodeExtensions::Post::Model.first_or_new common.merge(:title => 'Blog Post', :state => :published)
n.children << NodeExtensions::TextBlock::Model.all.last
n.children << NodeExtensions::TextBlock::Model.first
n.children << NodeExtensions::Table::Model.first
n.save if n.new?

n = NodeExtensions::Post::Model.first_or_new common.merge(:title => 'Not About Us', :state => :published)
n.children << NodeExtensions::TextBlock::Model.first
n.children << NodeExtensions::Table::Model.first
n.save if n.new?

n = NodeExtensions::Page::Model.first_or_new common.merge(:title => 'About Us', :state => :published, :slug => 'about')
n.children << NodeExtensions::TextBlock::Model.first
n.children << NodeExtensions::List::Model.first
n.save if n.new?
