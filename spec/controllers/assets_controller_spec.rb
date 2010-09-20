describe 'AssetsController' do
  it 'should match the following routes' do
    #route(:controller => 'assets', :action => 'styles', :template => :example).should == '/assets/example/styles.css'

    #route_for(assets_styles_path(:template => :example)).should == '/assets/example/styles.css'
    #route_for(assets_styles_path(:template => :example, :format => 'sass')).should == '/assets/example/styles.sass'
    #route_for(assets_scripts_path(:template => :example)).should == '/assets/example/scripts.js'
  end

  it 'should generate the correct parameters from routes' do
    #params_from(:get, '/assets/example/styles.css').should == { :controller => 'assets', :actions => 'styles', :template => 'example', :format => 'css' }
    #params_from(:get, '/assets/example/styles.sass').should == { :controller => 'assets', :actions => 'styles', :template => 'example', :format => 'sass' }
    #params_from(:get, '/assets/example/scripts.js').should == { :controller => 'assets', :actions => 'scripts', :template => 'example', :format => 'js' }
  end
end
