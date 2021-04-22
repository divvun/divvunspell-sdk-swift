Pod::Spec.new { |spec|
  spec.name = 'DivvunSpell'
  spec.version = '1.0.0-beta.1'
  spec.summary = 'Spell checking library for ZHFST/BHFST spellers, with case handling and tokenization support.'
  spec.authors = {
    'Brendan Molloy' => 'brendan@bbqsrc.net',
  }
  spec.license = { :type => 'MIT OR Apache-2.0' }
  spec.homepage = 'https://github.com/divvun/divvunspell-sdk-swift'
  spec.macos.deployment_target = '10.10'
  spec.ios.deployment_target = '8.0'
  spec.pod_target_xcconfig = {
    'ENABLE_BITCODE' => 'NO',
    'LIBRARY_SEARCH_PATHS[sdk=iphoneos*][arch=arm64]' => '${PODS_TARGET_SRCROOT}/dist/aarch64-apple-ios',
    'LIBRARY_SEARCH_PATHS[sdk=iphonesimulator*][arch=x86_64]' => '${PODS_TARGET_SRCROOT}/dist/x86_64-apple-ios',
    'LIBRARY_SEARCH_PATHS[sdk=iphonesimulator*][arch=arm64]' => '${PODS_TARGET_SRCROOT}/dist/aarch64-apple-ios-sim',
    'LIBRARY_SEARCH_PATHS[sdk=macos*][arch=x86_64]' => '${PODS_TARGET_SRCROOT}/dist/x86_64-apple-darwin',
    'LIBRARY_SEARCH_PATHS[sdk=macos*][arch=arm64]' => '${PODS_TARGET_SRCROOT}/dist/aarch64-apple-darwin',
    'OTHER_LDFLAGS' => '-ldivvunspell',
  }
  spec.preserve_paths = ['dist/**/*']
  spec.source_files = ['src/**/*']
  spec.source = {
    :http => 'https://github.com/divvun/divvunspell-sdk-swift/releases/download/v#{spec.version}/cargo-pod.tgz',
  }
}
