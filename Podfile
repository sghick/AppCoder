
# 指定公共的 Specs
source 'https://github.com/CocoaPods/Specs.git'

target "AppCoder" do
    platform:ios, '9.0'
    use_frameworks!

    # cmp-framework
    pod 'SMRBaseCore', :git => 'git@github.com:sghick/framework-SMRBaseCore.git', :commit => '55610e8'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO' if config.build_settings['SDKROOT'] == 'iphoneos'
        end
    end
end
