/**********************************************************\

  Auto-generated ShackBrowserHelperPluginAPI.h

\**********************************************************/

#include <string>
#include <sstream>
#include <boost/weak_ptr.hpp>
#include "JSAPIAuto.h"
#include "BrowserHost.h"
#include "ShackBrowserHelperPlugin.h"

#ifndef H_ShackBrowserHelperPluginAPI
#define H_ShackBrowserHelperPluginAPI

class ShackBrowserHelperPluginAPI : public FB::JSAPIAuto
{
public:
    ////////////////////////////////////////////////////////////////////////////
    /// @fn ShackBrowserHelperPluginAPI::ShackBrowserHelperPluginAPI(const ShackBrowserHelperPluginPtr& plugin, const FB::BrowserHostPtr host)
    ///
    /// @brief  Constructor for your JSAPI object.
    ///         You should register your methods, properties, and events
    ///         that should be accessible to Javascript from here.
    ///
    /// @see FB::JSAPIAuto::registerMethod
    /// @see FB::JSAPIAuto::registerProperty
    /// @see FB::JSAPIAuto::registerEvent
    ////////////////////////////////////////////////////////////////////////////
    ShackBrowserHelperPluginAPI(const ShackBrowserHelperPluginPtr& plugin, const FB::BrowserHostPtr& host) :
        m_plugin(plugin), m_host(host)
    {
        registerMethod("echo",      make_method(this, &ShackBrowserHelperPluginAPI::echo));
        registerMethod("testEvent", make_method(this, &ShackBrowserHelperPluginAPI::testEvent));
        // registerMethod("add",       make_method(this, &ShackBrowserHelperPluginAPI::add));
        // registerMethod("call_shack",       make_method(this, &ShackBrowserHelperPluginAPI::call_shack));
        registerMethod("addSongs",  make_method(this, &ShackBrowserHelperPluginAPI::addSongs));

        
        // Read-write property
        registerProperty("testString",
                         make_property(this,
                                       &ShackBrowserHelperPluginAPI::get_testString,
                                       &ShackBrowserHelperPluginAPI::set_testString));
        
        // Read-only property
        registerProperty("version",
                         make_property(this,
                                       &ShackBrowserHelperPluginAPI::get_version));
    }

    ///////////////////////////////////////////////////////////////////////////////
    /// @fn ShackBrowserHelperPluginAPI::~ShackBrowserHelperPluginAPI()
    ///
    /// @brief  Destructor.  Remember that this object will not be released until
    ///         the browser is done with it; this will almost definitely be after
    ///         the plugin is released.
    ///////////////////////////////////////////////////////////////////////////////
    virtual ~ShackBrowserHelperPluginAPI() {};

    ShackBrowserHelperPluginPtr getPlugin();

    // Read/Write property ${PROPERTY.ident}
    std::string get_testString();
    void set_testString(const std::string& val);

    // Read-only property ${PROPERTY.ident}
    std::string get_version();

    // Method echo
    FB::variant echo(const FB::variant& msg);
    
    // Event helpers
    FB_JSAPI_EVENT(test, 0, ());
    FB_JSAPI_EVENT(echo, 2, (const FB::variant&, const int));

    // Method test-event
    void testEvent();

    // Test method
    // int add(int a, int b, int c);

    // real guts
    // void call_shack(const std::string& msg);
    void addSongs(const std::string& msg);

private:
    ShackBrowserHelperPluginWeakPtr m_plugin;
    FB::BrowserHostPtr m_host;

    std::string m_testString;
};

#endif // H_ShackBrowserHelperPluginAPI

