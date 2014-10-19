source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '7.0'
pod "ECSlidingViewController"
pod "InAppSettingsKit", '>= 2.0.1'
pod 'FSImageViewer', '>= 2.6'
#pod "MarqueeLabel", '>= 2.0.0'

# Crush Utility Belt
pod 'Sidecar'

# Update checker for Installr (installrapp.com)
pod 'Aperitif'

# Logging & Analytics
pod 'CocoaLumberjack'
pod 'CrashlyticsFramework'
pod 'CrashlyticsLumberjack'
pod 'TestFlightSDK'
pod 'FlurrySDK'

# Networking
pod 'AFNetworking'

# Various goodies
pod 'libextobjc'      # Useful macros and some craziness
#pod 'PixateFreestyle' # Style your app with CSS
pod 'FormatterKit'    # For all your string formatting needs
pod 'Asterism'        # Nice & fast collection operations

# You may want...
#pod 'PromiseKit'     # Promises/A+-alike
#pod 'Mantle'         # Github's model framework
#pod 'SSKeychain'     # Go-to keychain wrapper
#pod 'DateTools'      # Datetime heavy lifting


# Testing necessities
target 'Specs', :exclusive => true do
    pod 'Specta'
    pod 'Expecta'
    #pod 'OCMockito'
    
    # pod 'OHHTTPStubs'
end


# Inform CocoaPods that we use some custom build configurations
# Leave this in place unless you've tweaked the project's targets and configurations.
xcodeproj 'BeRoads',
'Debug_Staging'   => :debug,   'Debug_Production'   => :debug,
'Test_Staging'    => :debug,   'Test_Production'    => :debug,
'AdHoc_Staging'   => :release, 'AdHoc_Production'   => :release,
'Profile_Staging' => :release, 'Profile_Production' => :release,
'Distribution'    => :release


# After every installation, copy the license and settings plists over to our project
post_install do |installer|
    require 'fileutils'
    
    installer.project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
            config.build_settings['VALID_ARCHS'] = 'arm64 armv7 armv7s'
            config.build_settings['ARCHS'] = 'arm64 armv7 armv7s'
        end
    end
    
    if Dir.exists?('BeRoads/Resources/Settings.bundle') && File.exists?('Pods/Pods-Acknowledgements.plist')
        FileUtils.cp_r('Pods/Pods-Acknowledgements.plist', 'BeRoads/Resources/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
    end
    
    if File.exists?('Pods/Target Support Files/Pods/Pods-Environment.h')
        FileUtils.cp_r('Pods/Target Support Files/Pods/Pods-Environment.h', 'BeRoads/Pods-Environment.h', :remove_destination => true)
    end
end
