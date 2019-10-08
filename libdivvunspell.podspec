#
# Be sure to run `pod lib lint libdivvunspell.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'libdivvunspell'
  s.version          = '0.1.0'
  s.summary          = 'A short description of libdivvunspell.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Brendan Molloy/libdivvunspell'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Brendan Molloy' => 'brendan@technocreatives.com' }
  s.source           = { :git => 'https://github.com/Brendan Molloy/libdivvunspell.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.pod_target_xcconfig = {
    'CARGO_HOME': "$(HOME)/.cargo",
    'CARGO_FEATURES': "ffi",
    'LIBRARY_SEARCH_PATHS': '"${SRCROOT}/libdivvunspell/divvunspell/target/universal/release"'
  }
  s.script_phases = [
    {
      :name => "Build libdivvunspell with Cargo",
      :execution_position => :before_compile,
      :script => "pushd ${SRCROOT}/../../libdivvunspell/divvunspell/divvunspell && make xcodelipo",
      :shell_path => "/bin/sh"
    }
  ]
  s.preserve_paths = "libdivvunspell/divvunspell"
  s.source_files = 'libdivvunspell/Classes/**/*'
  s.libraries = 'divvunspell'
  s.vendored_libraries = 'libdivvunspell/divvunspell/target/universal/release/libdivvunspell.a'
  s.public_header_files = 'libdivvunspell/Classes/**/*.h'
#  s.static_framework = true
end
