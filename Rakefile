def build_app
  begin
    FileUtils.rm_r("#{Dir.home}/Desktop/Sweeper.app")
  rescue Errno::ENOENT
    puts "No Sweeper.app to remove in Desktop"
  end

  begin
    FileUtils.rm_r("#{Dir.home}/Desktop/Sweeper.xcarchive")
  rescue Errno::ENOENT
    puts "No Sweeper.xcarchive to remove in Desktop"
  end

  sh "xcodebuild -archivePath ~/Desktop/Sweeper -scheme Sweeper -configuration Release archive "
  sh "xcodebuild -exportArchive -exportFormat APP " \
      "-archivePath ~/Desktop/Sweeper.xcarchive -exportPath ~/Desktop/Sweeper"
end

def remove_derived_data
  require 'fileutils'
  derived_apps = Dir.glob("#{Dir.home}/Library/Developer/Xcode/DerivedData/*")
  sweeper_dir = derived_apps.select { |directory| directory.include?("Sweeper") }.first
  path_to_derived_debug_app = "#{sweeper_dir}/Build/Products/Debug/Sweeper.app"
  path_to_derived_release_app = "#{sweeper_dir}/Build/Products/Release/Sweeper.app"
  begin
    FileUtils.rm_r(path_to_derived_debug_app)
    FileUtils.rm_r(path_to_derived_release_app)
  rescue Errno::ENOENT
    puts "No derived data to delete"
  end
end

def replace_old_app_with_new
  sh "rm -rf /Applications/Sweeper.app"
  sh "mv #{Dir.home}/Desktop/Sweeper.app /Applications/Sweeper.app"
  sh "rm -rf #{Dir.home}/Desktop/Sweeper.xcarchive"
end

def update_pasteboard_service
  sh "/System/Library/CoreServices/pbs -update"
end

task :install do 
  build_app
  remove_derived_data
  replace_old_app_with_new
  update_pasteboard_service
end
