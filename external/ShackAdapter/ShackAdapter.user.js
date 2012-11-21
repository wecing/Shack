// ==UserScript==
// @name          ShackAdapter
// @version       0.0.1
// @namespace     http://wecing.org
// @description   Call Shack in xiami, instead of the flash client.
// @include       http://www.xiami.com/*
// @exclude       http://www.xiami.com/song/play*
// @require       http://code.jquery.com/jquery-latest.min.js
// ==/UserScript==

(function () {
    var shack_plugin = null;
    var adapter_controller = null;

    var xiamiAddSongs = null;
    var shackAddSongs = function (songs) {
        shack_plugin.addSongs(songs);
    }
    var shackActive = true;

    function toggleShackAdapter () {
        var t = $('#shack-indicator')[0];
        if (shackActive) {
            shackActive = false;
            t.innerHTML = 'off';
        } else {
            shackActive = true;
            t.innerHTML = 'on';
        }
    }

    $(document).ready(function() {
        unsafeWindow.toggleShackAdapter = toggleShackAdapter;
        shack_plugin = document.createElement('object');
        shack_plugin.setAttribute('id', 'shack_plugin');
        shack_plugin.setAttribute('type',
                                  'application/x-shackbrowserhelperplugin');
        shack_plugin.setAttribute('width', '0');
        shack_plugin.setAttribute('height', '0');
        document.body.appendChild(shack_plugin);

        var t = document.createElement('div');
        t.style.width = '70px';
        t.style.height = '35px';
        t.style.position = 'absolute';
        t.style.zIndex = 999999;
        t.style.right = '0px';
        t.style.top = '100px';
        t.innerHTML = "<p align='center'>" +
                        "shack: " +
                        "<a id='shack-indicator' color='red'"+
                           ">" +
                           // "onclick='toggleShackAdapter'>" +
                          "on" +
                        "</a>"
                      "</p>";
        adapter_controller = t;
        document.body.appendChild(t);

        t.addEventListener('click', function() {
            toggleShackAdapter();
        }, false);

        xiamiAddSongs = unsafeWindow.addSongs;
        unsafeWindow.addSongs = function (x) {
            if (shackActive) {
                shackAddSongs(x);
            } else {
                xiamiAddSongs(x);
            }
        };

        unsafeWindow.bar = adapter_controller;
    });
})();
