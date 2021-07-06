#
# Be sure to run `pod lib lint PoporFloatBT.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PoporFloatBT'
  s.version          = '1.1'
  s.summary          = 'PoporFloatBT 悬浮UIButton, PoporFloatTV 悬浮的tableview, 可以增加多个.'
  s.homepage         = 'https://gitee.com/popor/PoporFloatBT'
  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'popor' => '908891024@qq.com' }
  s.source           = { :git => 'https://gitee.com/popor/PoporFloatBT.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '8.0'
  
  s.default_subspec = 'FloatBT'
  
  s.subspec 'FloatBT' do |cs|
    cs.source_files = 'PoporFloatBT/Classes/PoporFloatBT.{h,m}'
    cs.requires_arc = true
    
  end
  
  s.subspec 'FloatTV' do |cs|
    cs.dependency 'PoporFloatBT/FloatBT'
    cs.dependency 'PoporAlertBubbleView'
    
    cs.source_files = 'PoporFloatBT/Classes/PoporFloatTV.{h,m}'
    cs.requires_arc = true
    
  end
  
end
