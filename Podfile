# Uncomment the next line to define a global platform for your project

abstract_target 'AnodaTurnTimerAbstract' do
    use_frameworks!
    inhibit_all_warnings!
    
    
    target 'AnodaTurnTimer' do
        platform :ios, '10.0'
        
        # UI Core
        
        pod 'SnapKit', '~> 4.0'
        
        # UI Controls
        pod 'SwiftySound'
        pod 'R.swift'
        pod 'Closures'
        pod 'IQKeyboardManagerSwift'
        # Analytics / Testing / Reporting

        pod 'Fabric'
        pod 'Crashlytics'
        
        pod 'UIImagePDF', :git=> 'git@github.com:anodamobi/UIImage-PDF.git', :branch => '0.9-beta1', :commit => '7d9dfbf'
        
        
        pod 'ReSwift', '~> 4.0.1'
        pod 'SwiftyUserDefaults'
    end

    target 'AnodaTurnTimerWatch Extension' do
        platform :watchos, '4.0'
        
        pod 'ReSwift', '~> 4.0.1'
        pod 'SwiftyUserDefaults'
        
        # UI Controls
        pod 'YOChartImageKit', '~> 1.1'
    end

end

