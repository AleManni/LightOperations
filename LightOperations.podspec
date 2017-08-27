Pod::Spec.new do |spec|
spec.platform = :ios
spec.ios.deployment_target = '9.0'
  spec.name = "LightOperations"
 spec.summary = "Light framework for asynchronous operations and operation queues"
spec.requires_arc = true
spec.version = "1.0.0"
spec.license = { :type => "MIT", :file => "LICENSE" }
spec.authors = { "Alessandro Manni" => "ale_manni@icloud.com" }
spec.homepage = "https://github.com/AleManni/LightOperations"
spec.social_media_url = "https://github.com/AleManni/LightOperations.git"
spec.source = { :git => "https://github.com/AleManni/LightOperations.git", :tag => "v#{spec.version}" }
  spec.module_name = "LightOperations" 
  spec.source_files = "LightOperations/**/*.{swift}"
end