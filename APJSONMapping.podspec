Pod::Spec.new do |s|
  s.name         = "APJSONMapping"
  s.version      = "1.0"
  s.summary      = "Objective-C class category which allows you to easily map your objects to dictionaries and vice versa."
  
  s.description  = "Objective-C class extension which allows you to easily map your objects to dictionaries and parse your objects from dictionaries."

  s.homepage     = "https://github.com/aperechnev/APJSONMapping"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Alexander Perechnev" => "herfleisch@me.com" }
  s.source       = { :git => "https://github.com/aperechnev/APJSONMapping.git", :tag => "1.0" }

  s.platform     = :ios, '8.0'
  s.source_files = 'APJSONMapping/APJSONMapping/*.{h,m}'
  s.requires_arc = true
end
