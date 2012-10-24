// ==UserScript==
// @name          ShackAdapter
// @version       0.0.1
// @namespace     http://wecing.org
// @description   Call Shack in xiami, instead of the flash client.
// @include       http://www.xiami.com/*
// @require       http://code.jquery.com/jquery-latest.min.js
// ==/UserScript==

(function () {
    $(document).ready(function() {
        var shack_plugin = document.createElement('object');
        shack_plugin.setAttribute('id', 'shack_plugin');
        shack_plugin.setAttribute('type',
                                  'application/x-shackbrowserhelperplugin');
        shack_plugin.setAttribute('width', '0');
        shack_plugin.setAttribute('height', '0');
        document.body.appendChild(shack_plugin);
        unsafeWindow.addSongs = function (songs) {shack_plugin.addSongs(songs);}
    });
})();
