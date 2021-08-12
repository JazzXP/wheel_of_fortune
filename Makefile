macos:
	flutter build macos --release
	cd /build/macos/Build/Products
	rm -rf wheel_of_fortune
	mkdir wheel_of_fortune
	cp -r Release/Wheel\ Of\ Fortune.app wheel_of_fortune
	create-dmg --volname "Application Installer" --volicon 1024.icns --background mac-installer-1.png --window-pos 200 120 --window-size 600 400 --icon-size 100 --icon "Wheel Of Fortune.app" 150 190 --hide-extension "Wheel Of Fortune.app" --app-drop-link 450 185 wheel.dmg wheel_of_fortune

web:
	docker build -t registry.sdickinson.dev/wheel_of_fortune .
	docker push registry.sdickinson.dev/wheel_of_fortune:latest

.PHONY: macos web