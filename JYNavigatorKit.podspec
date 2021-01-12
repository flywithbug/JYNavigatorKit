#
# Be sure to run `pod lib lint JYNavigatorKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JYNavigatorKit'
  s.version          = '0.0.6'
  s.summary          = 'app '


  s.description      = <<-DESC
        app 
                       DESC

  s.homepage         = 'https://github.com/flywithbug/JYNavigatorKit.git'
  s.license          = 'MIT'
  s.author           = { 'flywithbug' => 'flywithbug@gmail.com' }
  s.source           = { :git => 'https://github.com/flywithbug/JYNavigatorKit.git', :tag => s.version }

  s.ios.deployment_target = '10.0'
  s.static_framework = true
    
    
  if ENV['is_frameworks'] and (ENV['is_not_frameworks'].nil? or !ENV['is_not_frameworks'].include? "_"+s.name+"_")
          s.vendored_frameworks = 'JYNavigatorKit/**/JYNavigatorKit.framework'
  else
      s.source_files = 'Pod/Classes/**/*.{h,m}'
  end

end
