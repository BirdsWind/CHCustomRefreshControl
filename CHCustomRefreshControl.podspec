Pod::Spec.new do |s|
  s.name         = "CHCustomRefreshControl"
  s.version      = "0.0.1"
  s.summary      = "CHCustomRefreshControl is a customized refresh control, neat"

  s.description  = <<-DESC
                   Like it neat, use mine :D 
                   DESC

  s.homepage     = "https://github.com/TokyoBirdy"
  s.screenshots  = "https://www.dropbox.com/s/wvpx6b639ujjw1x/Custom%20refresh.mov"
  s.license      = "MIT"
  s.author       = "Cecilia Humlelu"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/TokyoBirdy/customRefreshControl.git", :tag => "0.0.1" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.public_header_files = "CHRefreshControl/**/*.h"

end
