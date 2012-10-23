/**********************************************************\

  Auto-generated ShackBrowserHelperPluginAPI.cpp

\**********************************************************/

#include "JSObject.h"
#include "variant_list.h"
#include "DOM/Document.h"
#include "global/config.h"

#include "ShackBrowserHelperPluginAPI.h"

///////////////////////////////////////////////////////////////////////////////
/// @fn FB::variant ShackBrowserHelperPluginAPI::echo(const FB::variant& msg)
///
/// @brief  Echos whatever is passed from Javascript.
///         Go ahead and change it. See what happens!
///////////////////////////////////////////////////////////////////////////////
FB::variant ShackBrowserHelperPluginAPI::echo(const FB::variant& msg)
{
    static int n(0);
    fire_echo("So far, you clicked this many times: ", n++);

    // return "foobar";
    return msg;
}

///////////////////////////////////////////////////////////////////////////////
/// @fn ShackBrowserHelperPluginPtr ShackBrowserHelperPluginAPI::getPlugin()
///
/// @brief  Gets a reference to the plugin that was passed in when the object
///         was created.  If the plugin has already been released then this
///         will throw a FB::script_error that will be translated into a
///         javascript exception in the page.
///////////////////////////////////////////////////////////////////////////////
ShackBrowserHelperPluginPtr ShackBrowserHelperPluginAPI::getPlugin()
{
    ShackBrowserHelperPluginPtr plugin(m_plugin.lock());
    if (!plugin) {
        throw FB::script_error("The plugin is invalid");
    }
    return plugin;
}

// Read/Write property testString
std::string ShackBrowserHelperPluginAPI::get_testString()
{
    return m_testString;
}

void ShackBrowserHelperPluginAPI::set_testString(const std::string& val)
{
    m_testString = val;
}

// Read-only property version
std::string ShackBrowserHelperPluginAPI::get_version()
{
    return FBSTRING_PLUGIN_VERSION;
}

void ShackBrowserHelperPluginAPI::testEvent()
{
    fire_test();
}

int ShackBrowserHelperPluginAPI::add(int a, int b, int c) {
    return a + b + c;
}

void ShackBrowserHelperPluginAPI::call_shack(const std::string& msg) {
    // system() is blocking; it will block the whole page as well.
    int pid = fork();
    if (pid == 0) {
        std::string cmd = "shack-cli " + msg;
        system(cmd.c_str());
        exit(0);
    }
}
