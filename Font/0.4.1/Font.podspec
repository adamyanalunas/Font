#
# Be sure to run `pod lib lint Font.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Font"
  s.version          = "0.4.1"
  s.summary          = "Working with UIFont for custom fonts sucks—especially Dynamic Type. Font makes things easier."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
  Custom fonts are great. Swift is pretty great. But UIFont is still stringly-typed. And then there's dealing with Dynamic Type.

  Font allows you to deal with fonts in a strongly-typed manner with no pain when it comes to Dynamic Type.

  * Register your custom font and its sizes
  * Implement it
  * Register something to update the font size when the Dynamic Font size changes
  * Keep being awesome
                       DESC

  s.homepage         = "https://github.com/adamyanalunas/Font"
  s.license          = 'MIT'
  s.author           = { "Adam Yanalunas" => "adam@yanalunas.com" }
  s.source           = { :git => "https://github.com/adamyanalunas/Font.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
end
