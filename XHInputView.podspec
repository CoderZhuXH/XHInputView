Pod::Spec.new do |s|
  s.name         = "XHInputView"
  s.version      = "1.0.2"
  s.summary      = "轻量级评论输入框,支持多种样式,支持设置占位符等等..."
  s.homepage     = "https://github.com/CoderZhuXH/XHInputView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "Zhu Xiaohui" => "977950862@qq.com"}
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/CoderZhuXH/XHInputView.git", :tag => s.version }
  s.source_files = "XHInputView", "*.{h,m}"
  s.requires_arc = true
end
