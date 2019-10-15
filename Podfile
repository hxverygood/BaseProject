source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/aliyun/aliyun-specs.git'

# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'BaseProject' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # 必选Pods
  pod 'AFNetworking'
  pod 'MJRefresh'
  pod 'YYKit'
  pod 'SVProgressHUD'
  pod 'CYLTableViewPlaceHolder'
  pod 'KVOController'                                    # Facebook
  pod 'QMUIKit'                                         # 腾讯UI工具集

  
  # 可选Pods
  pod 'LookinServer', :configurations => ['Debug']      # 调试工具
  
  
  target 'BaseProjectTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'BaseProjectUITests' do
    # Pods for testing
  end

end
