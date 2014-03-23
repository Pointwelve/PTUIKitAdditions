Pod::Spec.new do |spec|

  spec.name         = "PTUIKitAdditions"
  spec.version      = "0.0.2"
  spec.summary      = "Collection of UIKit categories"
  spec.homepage     = "https://github.com/Pointwelve/PTUIKitAdditions"
  spec.authors      = { "Ryne Cheow" => "rynecheow@gmail.com" }
  
  spec.license = { :type => 'MIT', :file => 'LICENSE' }

  spec.requires_arc = true

  spec.frameworks = 'UIKit', 'CoreGraphics', 'QuartzCore'
  spec.source_files = 'PTUIKitAdditions/*.{h,m}'
  spec.platform     = :ios, '7.0'
  spec.source = { :git => 'https://github.com/Pointwelve/PTUIKitAdditions.git', :tag => "v#{spec.version}" }

end
