## About

Shack is an unofficial Mac OS client for [xiami.com](www.xiami.com).

![Shack screenshot](https://raw.github.com/wecing/Shack/master/resources/screenshot.png "Shack")

(Why am I writing in English?)

With Shack, you could play songs hosted on xiami directly from the webpage, just like how you used to.

Shack itself, consists of three parts: the Mac client, a browser plug-in, and an userscript.

### Building

Shack contains submodules, so please use --recursive when cloning the repo.

The client uses ___WKAudioStreamer___ (which is written by myself), ___GDCAsyncSocket___ and ___SPMediaKeyTap___.

Shack's browser plugin is built with ___FireBreath___. To compile the plugin, download FireBreath first; then:

	1. cd Shack/external/ShackBrowserHelperPlugin
	2. path-to-firebreath/prepmac.sh project/ build/
	3. cd build/
	4. xcodebuild
	5. cp -r projects/ShackBrowserHelperPlugin/Debug/ShackBrowserHelperPlugin.plugin /Library/Internet\ Plug-Ins/
	
I have no idea why I failed to compile it in Xcode. Maybe I used Xcode the wrong way.

If you don't have `xcodebuild`, download `Command Line Tools` from Xcode (`Preferences -> Downloads -> Components`).

### Installing the userscript

To change the webpage on xiami.com, you would have to install GreaseMonkey. After that you need to install the userscript, which is under `Shack/external/ShackAdapter`.