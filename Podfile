source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'beroads' do

  # SlidingView
  pod "ECSlidingViewController", :git => "https://github.com/ValCapri/ECSlidingViewController.git", :branch => "develop"
  
  # Settings in app
  pod "InAppSettingsKit", '>= 2.0.1'
  
  # ScrollView to zoom on image
  pod 'FSImageViewer', '~> 3.4'
  
  # Label animation
  pod 'MarqueeLabel', '>= 2.0.0'
  
  # Notification
  pod 'CSNotificationView'
  pod 'CSNotificationView-AFNetworking', :git => 'https://github.com/ValCapri/CSNotificationView-AFNetworking.git'
  
  # EmptyDataSet
  pod 'DZNEmptyDataSet'
  
  # Crush Utility Belt
  pod 'Sidecar'
  
  # Logging & Analytics
  pod 'CocoaLumberjack/Default'
  pod 'Crashlytics'
  pod 'CrashlyticsLumberjack', '~>2.0.0'
  
  # Networking
  pod 'AFNetworking'
  
  # Various goodies
  #pod 'libextobjc'      # Useful macros and some craziness
  #pod 'PixateFreestyle' # Style your app with CSS
  #pod 'FormatterKit'    # For all your string formatting needs
  #pod 'Asterism'        # Nice & fast collection operations
  
  # You may want...
  #pod 'PromiseKit'     # Promises/A+-alike
  #pod 'Mantle'         # Github's model framework
  #pod 'SSKeychain'     # Go-to keychain wrapper
  #pod 'DateTools'      # Datetime heavy lifting
  
  # Update checker for Installr (installrapp.com)
  #pod 'Aperitif', :configurations => ['Debug_Staging', 'AdHoc_Production']
  
  # Testing necessities
  target 'Specs' do
      pod 'Specta'
      pod 'Expecta'
      #pod 'OCMockito'
      
      #pod 'OHHTTPStubs'
  end
  
  
  # Inform CocoaPods that we use some custom build configurations
  # Leave this in place unless you've tweaked the project's targets and configurations.
  project 'BeRoads',
  'Debug_Staging'   => :debug, 'Test_Staging'    => :debug,
  'Test_Production' => :release, 'AdHoc_Production' => :release,
  'Profile_Production' => :release, 'Distribution'    => :release
  
  
  # After every installation, copy the license and settings plists over to our project
  post_install do |installer|
      require 'fileutils'
      
      if Dir.exists?('BeRoads/Resources/Settings.bundle') && File.exists?('Pods/Target Support Files/Pods/Pods-Acknowledgements.plist')
          FileUtils.cp('Pods/Target Support Files/Pods/Pods-Acknowledgements.plist', 'BeRoads/Resources/Settings.bundle/Acknowledgements.plist')
      end
      
      if File.exists?('Pods/Target Support Files/Pods/Pods-Environment.h')
          FileUtils.cp('Pods/Target Support Files/Pods/Pods-Environment.h', 'BeRoads/Pods-Environment.h')
      end
  end
end
