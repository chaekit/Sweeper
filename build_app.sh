rm -f "~/Desktop/Sweeper.app"

xcodebuild -archivePath ~/Desktop/Sweeper -scheme Sweeper -configuration Release archive 
xcodebuild -exportArchive -exportFormat APP -archivePath ~/Desktop/Sweeper.xcarchive -exportPath ~/Desktop/Sweeper

rm -rf /Applications/Sweeper.app
mv ~/Sweeper.app /Applications/Sweeper.app
/System/Library/CoreServices/pbs -update
