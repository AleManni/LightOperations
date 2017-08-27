Pod::Spec.new do |s|
  spec.name         = 'LightOperations'
  spec.version      = '1.0.0'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/AleManni/LightOperations'
  spec.authors      = { 'Alessandro Manni' => 'ale_manni@icloud.com' }
  spec.summary      = 'Light framework for asynchronous operations and operation queues'
  spec.source       = { :git => 'https://github.com/AleManni/LightOperations.git', :tag => 'v3.1.0' }
  spec.source_files = 'LightOperations', 'LightOperations/**/*.{h,m}'
  spec.framework    = 'SystemConfiguration'
end