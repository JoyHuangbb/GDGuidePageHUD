Pod::Spec.new do |spec|
  spec.name         = "GDGuidePageHUD"
  spec.version      = "0.0.1"
  spec.ios.deployment_target = '8.0'
  spec.summary      = "高达iOS自定义引导页" 
  # spec.description  = "公司自己风格的引导页"
  spec.homepage     = "https://github.com/JoyHuangbb/GDGuidePageHUD"
  spec.social_media_url = 'https://www.baidu.com'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' } 
  spec.author       = { "黄彬彬" => "746978660@qq.com" }
  spec.platform        = :ios, '8.0' 
  spec.source       = { :git => "https://github.com/JoyHuangbb/GDGuidePageHUD.git", :tag => spec.version}
  spec.requires_arc = true
  spec.frameworks    = 'UIKit'
  spec.source_files = 'GDGuidePageHUD/*'
  spec.resource    = 'GDGuidePageHUD/GDGuideImage.bundle' #资源，比如图片，音频文件等

end
