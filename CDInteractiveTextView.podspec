Pod::Spec.new do |s|
  s.name             = 'CDInteractiveTextView'
  s.version          = '0.1.1'
  s.summary          = 'A customized UITextView to introduce tappable links.'
  s.description      = <<-DESC
A customized UITextView to introduce tappable links. Hehe.
                       DESC

  s.homepage         = 'https://github.com/carlos21/CDInteractiveTextView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Carlos Duclos' => 'darkzeratul64@gmail.com' }
  s.source           = { :git => 'https://github.com/carlos21/CDInteractiveTextView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'CDInteractiveTextView/Classes/**/*'

end
