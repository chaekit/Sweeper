rm -rf "/Users/jaychae/Desktop/Sweeper.app"

xcodebuild -archivePath /Users/jaychae/Desktop/Sweeper -scheme Sweeper -configuration Release archive 
xcodebuild -exportArchive -exportFormat APP -archivePath /Users/jaychae/Desktop/Sweeper.xcarchive -exportPath /Users/jaychae/Desktop/Sweeper

rm -rf /Applications/Sweeper.app
mv /Users/jaychae/Desktop/Sweeper.app /Applications/Sweeper.app
