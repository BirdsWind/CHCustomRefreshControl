Pod::Spec.new do |s|
  s.name         = "CHCustomRefreshControl"
  s.version      = "0.0.3"
  s.summary      = "CHCustomRefreshControl is a customized refresh control, neat"

  s.description  = <<-DESC
                   CHCustomRefreshControl is a customized refresh control, like it neat, try that out
                   DESC

  s.homepage     = "https://github.com/TokyoBirdy"
  s.license      = "MIT License"
  s.author       = "Cecilia Humlelu"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/TokyoBirdy/customRefreshControl.git", :tag => "0.0.3" }
  s.source_files = "CHCustomRefreshControl/*.{h,m}"
  s.requires_arc = true

end
