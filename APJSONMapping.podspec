Pod::Spec.new do |s|
  s.name         = "APJSONMapping"
  s.version      = "2.0"
  s.summary      = "Objective-C class category which allows you to easily map your objects to JSON strings and vice versa."
  
  s.description  = "Objective-C class extension which allows you to easily map your objects to JSON strings and parse JSON back to your objects."

  s.homepage     = "https://github.com/alexkrzyzanowski/APJSONMapping"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Alex Krzyżanowski" => "alex.krzyzanowski@icloud.com" }
  s.source       = { :git => "https://github.com/alexkrzyzanowski/APJSONMapping.git", :tag => "2.0" }

  s.platform     = :ios, '8.4'
  s.source_files = 'APJSONMapping/APJSONMapping/*.{h,m}'
  s.requires_arc = true
end
