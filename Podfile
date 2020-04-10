# 最低版本
platform :ios, '8.0'

# 禁止警告
inhibit_all_warnings!

# 公有仓库
source 'https://github.com/CocoaPods/Specs.git'
# 私有仓库
# source 'https://git.coding.net/PrivateSpecs.git'

target 'FreeNoteBook' do
    
    # 公有仓库 - 自动布局框架
    pod 'Masonry', '~> 1.1.0'
    # 公有仓库 - 离散网络请求框架
    pod 'YTKNetwork', '~>2.0.4', :inhibit_warnings => true
    # 公有仓库 - 集约网络请求框架
    pod 'AFNetworking', '~>3.2.1', :inhibit_warnings => true
    # 公有仓库 - 图片加载框架
    pod 'SDWebImage', '~> 4.2.2'
    # 公有仓库 - 字典和模型转换框架
    pod 'MJExtension', '~> 3.0.13'
    # 公有仓库 - 弹出提示信息框
    pod 'Toast', '~> 4.0.0'
    # 公有仓库 - 弹出进度提示框
    pod 'MBProgressHUD', '~> 1.0.0'
    pod 'SVProgressHUD', '~> 2.2.5'
    # 公有仓库 - 加载动画菊花框架
    pod 'DGActivityIndicatorView', '~> 2.1.1'

    # 公有仓库 - 数据存储框架
    pod 'FMDB', '~> 2.7.5'
    # 公有仓库 - 数据缓存框架
    pod 'YYCache', '1.0.4'
    # 公有仓库 - 图表框架
    pod 'PNChart', '~> 0.8.9'
    # 公有仓库 - 选择插件框架
    pod 'CZPicker', '~> 0.4.3'
    # 公有仓库 - 下拉刷新框架
    pod 'MJRefresh', '~> 3.1.15.7'
    # 公有仓库 - 数字键盘框架
    pod 'MMNumberKeyboard', '~> 0.2.1'
    # 公有仓库 - 导航栏按钮位置偏移的解决方案
    pod 'UINavigation-SXFixSpace', '~> 1.2.4'
    
end

# 删除警告
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 8.0
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
            end
        end
    end
end


