#
# Be sure to run `pod lib lint libdivvunspell.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'libdivvunspell'
  s.version          = '0.1.4'
  s.summary          = 'A short description of libdivvunspell.'
  s.swift_versions = "5.0"
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/bbqsrc/divvunspell-swift'
  s.license          = { :type => 'Apache-2.0 OR MIT' }
  s.author           = { 'Brendan Molloy' => 'brendan@bbqsrc.net' }
  s.source           = { :git => 'https://github.com/bbqsrc/divvunspell-swift.git', :submodules => true, :tag => s.version.to_s }

  s.macos.deployment_target = '10.10'
  s.ios.deployment_target = '8.0'
  s.pod_target_xcconfig = {
    'CARGO_HOME': "$(HOME)/.cargo",
    'CARGO_FEATURES': "ffi",
    'OTHER_LDFLAGS': '-ldivvunspell',
    'ENABLE_BITCODE': 'NO'
  }
  s.macos.pod_target_xcconfig = {
    'LIBRARY_SEARCH_PATHS': '"${PODS_TARGET_SRCROOT}/libdivvunspell/divvunspell/target/release"'
  }
  s.ios.pod_target_xcconfig = {
    'LIBRARY_SEARCH_PATHS': '"${PODS_TARGET_SRCROOT}/libdivvunspell/divvunspell/target/universal/release"'
  }
  s.ios.script_phases = [
    {
      :name => "Build libdivvunspell with Cargo",
      :execution_position => :before_compile,
      :script => "pushd ${PODS_TARGET_SRCROOT}/libdivvunspell/divvunspell/divvunspell && make xcodelipo",
      :shell_path => "/bin/sh"
    }
  ]
  s.macos.script_phases = [
    {
      :name => "Build libdivvunspell with Cargo",
      :execution_position => :before_compile,
      :script => "pushd ${PODS_TARGET_SRCROOT}/libdivvunspell/divvunspell/divvunspell && ${CARGO_HOME}/bin/cargo build --lib --release --features ${CARGO_FEATURES} && rm ${PODS_TARGET_SRCROOT}/libdivvunspell/divvunspell/target/release/*.dylib",
      :shell_path => "/bin/sh"
    }
  ]
  s.preserve_paths = "libdivvunspell/divvunspell"
  s.source_files = 'libdivvunspell/Classes/**/*'
  s.ios.vendored_libraries = 'libdivvunspell/divvunspell/target/universal/release/libdivvunspell.a'
  s.macos.vendored_libraries = 'libdivvunspell/divvunspell/target/release/libdivvunspell.a'
  s.public_header_files = 'libdivvunspell/Classes/**/*.h'
#  s.static_framework = true
end
