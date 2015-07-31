Pod::Spec.new do |s|

s.name = 'ServerAccessSDK'
s.version = '0.0.1'
s.license = 'MIT'
s.summary = 'Server Access SDK'
s.homepage = 'https://github.com/tomyhero/swift-ServerAccessSDK'
s.authors = { 'Tomohiro Teranishi' => 'tomohiro.teranishi@gmail.com' }
 s.source = { :git => 'https://github.com/tomyhero/swift-ServerAccessSDK.git', :tag => s.version }
s.source_files = 'ServerAccessSDK/*.swift'

s.osx.deployment_target = "10.9"
s.ios.deployment_target = "8.0"


s.dependency 'Alamofire', '~> 1.2.3'
s.dependency 'SwiftyJSON', '~> 2.2.0'

end
