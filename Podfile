# Uncomment the next line to define a global platform for your project
platform :osx, '10.13'

plugin 'cocoapods-keys', {
  :project => "Translate Bar",
  :keys => [
    'YandexDictionaryKey',
    'YandexTranslateKey'
  ]
}

target 'Translate Bar' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Translate Bar
  pod 'SwiftyBeaver'

  pod 'RxSwift',    '~> 4.0'
  pod 'RxCocoa',    '~> 4.0'

  pod 'Moya/RxSwift', '~> 11.0'

  pod 'EVReflection/MoyaRxSwift'
  
  # UI
  pod 'ITSwitch'

  target 'Translate BarTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Translate BarUITests' do
    inherit! :search_paths
    # Pods for testing
  end
end
