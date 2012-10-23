### About

Nothing interesting for now. Seriously.

### Building

If you really want to do so...

Shack itself doesn't have any extra dependencies; ___GCDAsyncSocket___ is already included.

But Shack's browser plugin is built with ___FireBreath___. To compile the plugin, download FireBreath first; then:

	1. cd shack/external/ShackBrowserHelperPlugin
	2. path-to-firebreath/prepmac.sh project/ build/
	3. cd build/
	4. xcodebuild
	5. ln -s projects/ShackBrowserHelperPlugin/Debug/ShackBrowserHelperPlugin.plugin /Library/Internet\ Plug-Ins/
	
I have no idea why I failed to compile it in Xcode. Maybe I used Xcode the wrong way.

If you don't have `xcodebuild`, download `Command Line Tools` from Xcode first (Preferences->Downloads->Components).