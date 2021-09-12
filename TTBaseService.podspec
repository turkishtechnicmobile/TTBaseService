Pod::Spec.new do |spec|
  spec.name         = 'TTBaseService'
  spec.version      = '0.0.3'
  spec.authors      = { 
    'Hasan KACAR' => 'hasankacar@thy.com'
  }
  spec.license      = { 
    :type => 'MIT',
    :file => 'LICENSE' 
  }
  spec.homepage     = 'https://github.com/turkishtechnicmobile/TTBaseService'
  spec.source       = { 
    :git => 'https://github.com/turkishtechnicmobile/TTBaseService.git', 
    :branch => 'master',
    :tag => spec.version.to_s 
  }
  spec.summary      = 'Base application frameworks for Turkish Technic\'s Applications. Don\'t use it without permission.'
  spec.source_files = '**/*.swift', '*.swift'
  spec.swift_versions = '4.2'
  spec.ios.deployment_target = '11.0'
  
  spec.dependency 'ObjectMapper', '~> 4.2.0'
  spec.dependency 'Alamofire', '~>4.9.1'
  spec.dependency 'TTBaseModel'
  spec.dependency 'TTBaseApp'
end