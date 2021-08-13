macos:
	flutter build macos --release
macos_installer: macos
	rm wheel.dmg
	rm -rf build/macos/Build/Products/wheel_of_fortune
	mkdir build/macos/Build/Products/wheel_of_fortune
	cp -r build/macos/Build/Products/Release/Wheel\ Of\ Fortune.app build/macos/Build/Products/wheel_of_fortune/
	create-dmg --volname "Application Installer" --volicon "build/macos/Build/Products/1024.icns" --background "build/macos/Build/Products/mac-installer-1.png" --window-pos 200 120 --window-size 600 400 --icon-size 100 --icon "Wheel Of Fortune.app" 150 190 --hide-extension "Wheel Of Fortune.app" --app-drop-link 450 185 wheel.dmg build/macos/Build/Products/wheel_of_fortune

web:
	docker build -t registry.sdickinson.dev/wheel_of_fortune .
	docker push registry.sdickinson.dev/wheel_of_fortune:latest

.PHONY: macos web macos_installer