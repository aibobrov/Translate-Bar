platform :osx, '10.13'

plugin 'cocoapods-keys', {
  :project => "TranslateBar",
  :keys => [
    'YandexDictionaryKey',
    'YandexTranslateKey'
  ]
}

target 'TranslateBar' do
  use_frameworks!

  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Moya/RxSwift'
  pod 'KeyHolder'  
  pod 'ITSwitch'

  target 'TranslateBarTests' do
    inherit! :search_paths
  end

end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
