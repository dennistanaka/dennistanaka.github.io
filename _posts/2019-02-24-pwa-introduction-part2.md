---
layout:    post
title:     "Progressive Web Apps - Part 2"
date:      2019-02-24 13:50:32 +0900
published: false
---

# Introduction

In this second part on the series ([Part 1 here](/2019/02/19/pwa-introduction-part1.html)), we are going to take a deeper look on application manifests and start talking about service workers.

# The Web App Manifest

## Browser Support

A line like the below, mentioned before, is used activate the application manifest.

{% highlight html %}
<link rel="manifest" href="/manifest.json">
{% endhighlight %}

If the application is accessed by unsupported browsers, this line will simply be ignored, so the app can still be used without problems.

The current state of browser support for the web app manifest can be found at [Web App Manifest - Can I Use](https://caniuse.com/#feat=web-app-manifest).

## Demo Application

For the remaining of this series of articles, I prepared a very basic project that can be used to practice what was learned. At this point, it has the minimum we need to start building upon: the main screen with an example journal entry and a button that opens a modal to add new entries, navigation and a help page. Also, the project already contains a web app manifest.

You can find the project in the link below and the only requirement is to have [Node.js](https://nodejs.org/) installed.

[https://github.com/dennistanaka/progressive-journal](https://github.com/dennistanaka/progressive-journal)

Clone the project to your machine and run:

{% highlight bash %}
$ npm install
$ npm start
{% endhighlight %}

This will install the http-server package and start the development server. You can open the application by accessing the address that the server outputs and you can probably access `http://localhost:8080` by default.

![The Demo App](/assets/images/blog/pwa-introduction-part2-demo_app.png){: width="320px"}

*The Demo App*

## Chrome Dev Tools

After starting the application as described in the previous item, we can now check the validity of our app manifest file by opening the "Developer Tools" in Chrome. In the tools, we can check the "Application" tab and click the "Manifest" option in the sidebar, as shown below:

![The App Manifest section in Chrome's Developer Tools](/assets/images/blog/pwa-introduction-part2-web_app_manifest_dev_tools.png){:width="450px"}

*The App Manifest section in Chrome's Developer Tools*

This section should display errors and warnings in the case of issues with the manifest.json file.

## Android Emulator

During the development process, we will probably want to test the app on an actual device. This way, we can add a shortcut to the app on the device's homescreen, for example.

But, instead of a real device, we can use the Android emulator that comes with [Android Studio](https://developer.android.com/studio). We are not going to cover the installation of Android Studio, but it should be straightforward to install it with the default options.

After starting Android Studio, we want to start a virtual device to test our application. Unfortunately, it is only possible to do that within a project. So, we need create a new project and it is OK to do that using the default settings.

With a new project opened, we can access the virtual devices manager by selecting "Tools" > "AVD Manager" or by clicking the "AVD Manager" icon in the toolbar. After that, it is necessary to create a new virtual device and the article [Create and manage virtual devices](https://developer.android.com/studio/run/managing-avds.html) explains how to do so. Preferably, we want to use a virtual device with the most recent version of Android, as it should contain a quite recent version of Chrome installed, so we don't need to install a more recent version of it manually.

After creating and starting the virtual device, let's open Chrome. To access our application, we need to type `http://10.0.2.2:8080` in the address bar. This is the address that is mapped to the localhost in the virtual device. From there, we can use the "Add to Home screen" on Chrome to add a shortcut in our device.

![Add to Home screen](/assets/images/blog/pwa-introduction-part2-emulator_screenshot.png){: width="320px"}

*Add to Home screen*

# Service Workers

Now, it is time to work on service workers, the most important piece that makes an app a PWA. We already introduced the subject in [Part 1](/2019/02/19/pwa-introduction-part1.html), but we are going to go much deeper in the subject from now on.

The browser uses a single thread to run all the JavaScript in a page, as well as to perform layout, reflows, and garbage collection [[1](https://developer.mozilla.org/en-US/docs/Tools/Performance/Scenarios/Intensive_JavaScript)].

But, as mentioned before, service workers run in a separate thread from the JavaScript that runs on the web pages (the main thread). They run in the background, are decoupled from the HTML pages and have access to a different set of features compared to the main thread. They cannot access the DOM on the application pages directly, but because they run in the background, service workers can listen to events emitted by those pages and even listen to messages from other servers, to display push notifications, for example.

## Events

As mentioned above, service workers stays in the background listening for events. Below, some of the events service workers can react to are listed:

* `Fetch` - service workers can listen to fetch events, that are triggered every time a resource (an image file or a CSS file, for example) needed by the page is requested to the server by the browser. Thanks to the fetch event, service workers can intercept and manipulate those network requests, blocking them or returning cached assets, for example.
* `Push Notifications` - service workers can listen to push notification events even if the application is already close, helping bringing the users back to the application by showing useful notifications on their phones, for example. We can also react to the user interaction to those notifications through service workers, allowing us to program what happens when the user taps a push notification on their devices.
* `Background Synchronization` - on a situation of unstable internet access, we can schedule a user action to be synced to the remote server once the internet connection is re-established. This task can be performed by the service worker once it receives an event indicating the connection is back.
* `Lifecycle Events` - as we are going to see in the next section, we can program certain actions to be executed during the lifecycle of a service worker.

### The Service Worker Lifecycle

Service workers live in its own JavaScript file and need to be registered by the JavaScript code running in the main thread. Through the registration process, we request the browser to run our service worker code as a background process.

Registering a service worker will cause the browser to start the service worker install step in the background [[2](https://developers.google.com/web/fundamentals/primers/service-workers/#the_service_worker_life_cycle)]. This triggers the `install` event, when we have the opportunity to cache some static assets.

Also part of the registration process is the service worker activation, that triggers the `activate` event, when we can cleanup resources used in previous versions of a service worker script [[3](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API/Using_Service_Workers#Basic_architecture)]. Once it is activated, the service worker transitions to an `idle` state, when it is ready to handle functional events.

Because the code for the service worker registration runs in the main thread, it is run every time the application reloads. But, it is not the case for the installation process, as it is only run again if the service worker code changes.

Finally, when not in use, service workers are terminated what does not mean they are uninstalled, as they are automatically re-enabled when an event is triggered.

![Diagram of the states in the Service Worker Lifecycle](https://developers.google.com/web/fundamentals/primers/service-workers/images/sw-lifecycle.png){:width="450px"}

*States in the Service Worker Lifecycle. Image: [Service Workers](https://developers.google.com/web/fundamentals/primers/service-workers)*

## Browser Support

As we can check in [Is service worker ready?](https://jakearchibald.github.io/isserviceworkerready/), browser support is already very good.

According to [Can I use...](https://caniuse.com/#feat=serviceworkers), browser support currently covers more than 89% of the users.

## Registering a Service Worker

Now, it's time to register a service worker for the demo app mentioned before.

The first thing to do is to create a JavaScript file for the service worker. The location of this file is very important because it determines the scope of the service worker. In many cases, we want our service worker to be able to affect our entire application. To do so, we need to create the new file in the root folder of our project, that is the `public` folder in the case of our demo app.

So, we are going to create a new file called `sw.js`, although it can have any name we want.

Before implementing our service worker, let's register it in our `app.js` file. Because we don't know which page the user will access first, it is important to guarantee that the code to register the service worker run in all pages of our application. We can do so by executing the registration process in the `app.js` file because it is imported in both the main index.html and the help page index.html.

Let's add the code below to `/public/src/js/app.js`:

{% highlight javascript %}
if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/sw.js').then(() => console.log('Service worker registered'))
}
{% endhighlight %}

In the code above, we are checking if the browser supports service workers to avoid trying to run code that will not work. After that check, we are asking the browser to register the `/sw.js` file as a background process.

Now, let's start the development server if it's not started already and refresh our application. The console in the Dev Tools should output `Service worker registered` as expected. We can also check the "Service Worker" section in the "Application" tab, where it show that our service worker is activated and running.

![Service Worker Status in the Chrome Dev Tools](/assets/images/blog/pwa-introduction-part2-service_worker_status.png){:width="450px"}

*Service Worker Status in the Chrome Dev Tools*

## Reacting to Lifecycle Events

In this section, we are going to handle some events in the service worker lifecycle. Let's edit the `/sw.js` file we created previously:

{% highlight javascript %}
self.addEventListener('install', e => {
  console.log('[Service Worker] Installing the service worker...', e)
})

self.addEventListener('activate', e => {
  console.log('[Service Worker] Activating the service worker...', e)
  return self.clients.claim()
})
{% endhighlight %}

The line `return self.clients.claim()` ensures the service worker is activated correctly. It may become unnecessary in the future, but for now this helps make the registration process more robust. Now, let's refresh our application and we will see that the registration and installation `console.log()` are displayed in the "Console", but the activation output is not shown.

This is expected behavior and, if we take a look at the "Application" tab in "Chrome Dev Tools", we can see that our service worker shows a "waiting to activate" state. When your application is already open, service workers will be installed but not activated. The reason is: the application may still be interacting with the old service worker and activating a new version of the service worker which may contain breaking changes, can make the application misbehave. Therefore, we can make our service worker activate by closing the application (all the tabs/windows running the application) and reopening it.

If we do that, we will see the activation log will be displayed in the "Console" and the "Application" tab will no longer show the "waiting to activate" status. That's the behavior of the activation process of service workers, but we have a couple of ways to make a new version activate, as shown below:
* check the "Update on reload" option
* click "Update"
* click "Unregister" and then "Register"
* click "skipWaiting" when the service worker is in the "waiting to activate" state

## Reacting to Non-Lifecycle events

As the last step in this article, let's write an event handler to deal with the "Fetch" event, that is triggered whenever an asset is needed by the application.

{% highlight javascript %}
self.addEventListener('fetch', e => {
  console.log('[Service Worker] Fetching asset...', e)
  e.respondWith(fetch(e.request))
})
{% endhighlight %}

The method `e.respondWith` allow us to customize how to respond to each fetch event. For now, it was just placed here to call attention to it as we are not doing any manipulation.

# Conclusion

This is it for now. In the next article, we will introduce caching with service workers.

# References

1. [Intensive JavaScript - MDN](https://developer.mozilla.org/en-US/docs/Tools/Performance/Scenarios/Intensive_JavaScript)
2. [The Service Worker Life Cycle - Google Developers](https://developers.google.com/web/fundamentals/primers/service-workers/#the_service_worker_life_cycle)
3. [Using Service Workers - MDN](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API/Using_Service_Workers#Basic_architecture)
