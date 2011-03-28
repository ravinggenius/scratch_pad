require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the Admin::AddonsHelper. For example:
#
# describe Admin::AddonsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ApplicationHelper do
  describe '#body_attributes' do
    it 'should return a hash with :id and :class' do
      attrs = helper.body_attributes
      attrs.should countain(:id)
      attrs.should countain(:class)
    end
  end

  describe '#hash_to_attrs' do
    it 'should string a hash into html attributes' do
      helper.hash_to_attrs(:id => '54', :name => 'test54').should == 'id="54" name="test54"'
    end

    it 'should handle class keys special' do
      helper.hash_to_attrs(:class => 'one').should == 'class="one"'
      helper.hash_to_attrs(:class => ['one']).should == 'class="one"'
      helper.hash_to_attrs(:class => ['one', 'two']).should == 'class="one two"'
    end
  end

  describe '#obfuscate' do
  end

  describe '#options_from_collection_for_select' do
  end

  describe '#classy_html_tags' do
    before do
      # FIXME Rake::Task is not available here...
      `rake dev:reset`
    end

    let(:content) { '' }

    it 'should respect the element name' do
      helper.classy_html_tags(:html) { content }.should == <<-EXPECTED
<!--[if lt IE 7]>              <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US" lang="en-US" class="no-js ie ie6 lte9 lte8 lte7 lte6"> <![endif]--> 
<!--[if IE 7]>                 <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US" lang="en-US" class="no-js ie ie7 lte9 lte8 lte7">      <![endif]--> 
<!--[if IE 8]>                 <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US" lang="en-US" class="no-js ie ie8 lte9 lte8">           <![endif]--> 
<!--[if IE 9]>                 <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US" lang="en-US" class="no-js ie ie9 lte9">                <![endif]--> 
<!--[if (gt IE 9)|!(IE)]><!--> <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US" lang="en-US" class="no-js">                        <!--<![endif]-->
</html>
      EXPECTED

      helper.classy_html_tags(:body) { content }.should == <<-EXPECTED
<!--[if lt IE 7]>              <body xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US" lang="en-US" class="no-js ie ie6 lte9 lte8 lte7 lte6"> <![endif]--> 
<!--[if IE 7]>                 <body xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US" lang="en-US" class="no-js ie ie7 lte9 lte8 lte7">      <![endif]--> 
<!--[if IE 8]>                 <body xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US" lang="en-US" class="no-js ie ie8 lte9 lte8">           <![endif]--> 
<!--[if IE 9]>                 <body xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US" lang="en-US" class="no-js ie ie9 lte9">                <![endif]--> 
<!--[if (gt IE 9)|!(IE)]><!--> <body xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US" lang="en-US" class="no-js">                        <!--<![endif]-->
</body>
      EXPECTED
    end
  end
end
