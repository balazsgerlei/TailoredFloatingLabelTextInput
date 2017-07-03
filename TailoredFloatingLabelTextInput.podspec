Pod::Spec.new do |s|

# ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.name         = "TailoredFloatingLabelTextInput"
s.version      = "1.0.0"
s.summary      = "An iOS text input field written in Swift, tailored to your needs."

s.description  = <<-DESC
A highly customizable text input field written in Swift which have a floating label design pattern implementation among many other features. It has no external dependencies and can be used to implement not only Google's Material Design spec but many other designs as well.
DESC

s.homepage     = "https://github.com/AutSoft/TailoredFloatingLabelTextInput"

# ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.license = { :type => "MIT", :file => "LICENSE" }


# ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.authors = { 'AutSoft Kft.' => 'info@autsoft.hu', 'Balázs Gerlei' => 'gerlei.balazs@autsoft.hu' }


# ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.platform = :ios
s.ios.deployment_target = '9.0'


# ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.source = { :git => "https://github.com/AutSoft/TailoredFloatingLabelTextInput.git", :tag => "#{s.version}" }


# ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.source_files = "TailoredFloatingLabelTextInput/**/*.{swift}"


# ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.resources = "TailoredFloatingLabelTextInput/**/*.{png,jpeg,jpg,storyboard,xib}"


# ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.requires_arc = true

end
