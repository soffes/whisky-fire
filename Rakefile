desc 'Download the video'
task :download do
  unless File.exists?('Nick.mp4')
    # Check dependencies
    check_program 'youtube-dl'
    check_program 'ffmpeg'

    # Download
    system 'youtube-dl -f mp4 --output Nick-Original.mp4 LS-ErOKpO4E'

    # Trim
    system 'ffmpeg -ss 00:00:14.000 -i Nick-Original.mp4 -t 00:44:33.000 -c:v copy -c:a copy Nick.mp4'
    system 'rm -f Nick-Original.mp4'

    puts 'Done.'
  end
end

desc 'Build the screen savar'
task :build => :download do
  unless File.exists?('WhiskyFire.xcarchive')
    system 'xcrun xcodebuild -scheme WhiskyFire -configuration Release archive -archivePath WhiskyFire.xcarchive'
  end
end

desc 'Export the screen saver'
task :export => :build do
  system %Q{cp -R "WhiskyFire.xcarchive/Products/Users/#{`whoami`.chomp}/Library/Screen Savers/WhiskyFire.saver" .}
end

desc 'Install the screen saver'
task :install => :export do
  system 'open WhiskyFire.saver'
end

task :default => :install

desc 'Clean up'
task :clean do
  system 'rm -rf Nick-Original.mp4 Nick.mp4 WhiskyFire.xcarchive'
end

private

def check_program(name)
  if `which #{name}`.chomp.length == 0
    puts "\nYou need to install #{name} first. You can install it using Homebrew with the following command:\n\n    brew install #{name}\n\nIf you don’t have Homebrew, visit http://brew.sh for instructions.\n\n"
    abort
  end
end
