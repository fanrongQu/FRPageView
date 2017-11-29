 Pod::Spec.new do |s|
 s.name = 'FRPageView'
 s.version = '1.0.1'
 s.license = {:type => 'MIT', :file => "LICENSE"}
 s.summary = '自定义的一个轮播视图，接入简单（仿一号店效果）'
 s.authors = {'FR' => '1366225686@qq.com'}
 s.platform = :ios, '8.0'
 s.homepage = 'https://github.com/fanrongQu/FRPageView'
 s.source = {:git => 'https://github.com/fanrongQu/FRPageView.git', :tag =>s.version}
 s.source_files = "FRPageView" 
 s.ios.deployment_target = '8.0'

end

