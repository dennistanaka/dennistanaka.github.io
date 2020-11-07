---
layout:    post
title:     "Progressive Web Apps - Part 1"
date:      2019-02-19 23:50:27 +0900
published: false
---

# Introduction

This is the first part in a series of articles about Progressive Web Apps or PWAs. I am currently taking the following course at Udemy and I am writing these articles to help me consolidate the earned knowledge: [Progressive Web Apps (PWA) - The Complete Guide](https://www.udemy.com/progressive-web-app-pwa-the-complete-guide/)

# What are Progressive Web Apps

As you can notice by reading articles such as [Seriously, though. What is a progressive web app?](https://medium.com/@amberleyjohanna/seriously-though-what-is-a-progressive-web-app-56130600a093), it is very difficult to describe what a PWA actually is, but I will give it a try.

Progressive Web Apps (PWAs) are web applications that behaves like native mobile applications. They do so by using a set of techniques and technologies to provide end-users with features they usually find on native apps, such as:

* Background synchronization
* Push notifications
* Offline accessibility
* Location based behavior
* Device camera access
* Application shortcut in the home screen

It's difficult to define PWAs as there is not a single specific criteria to consider an app a PWA, so it is even more difficult (if not impossible) to call an app a "perfect" PWA. Because some of the recommended enhancements rely on modern web browser capabilities and new capabilities will surely create new recommended enhancements in the future, I believe it is not absurd to consider the goal of a "perfect" PWA unattainable. Not only that, but depending on the nature of your application, implementing some of the enhancements proposed for PWAs may not even make sense.

That said, as written in the article mentioned previously, there are three baseline criteria to qualify an app as a PWA:

1. It must run under HTTPS.
2. It must include a Web App Manifest.
3. It must implement a service worker.

The first criteria is quite straightforward and we will cover the other two later.

I'm not sure if it's completely accurate to consider an app a PWA once these three criterias are satisfied, but I like to think so, as it gives us an objective way to make this judgement. Even after we can call our app a Progressie Web App, we will always be striving to reach the goals proposed for PWAs, such as making our apps more reliable, faster and more engaging [[1](https://developers.google.com/web/progressive-web-apps/)].

# Core Building Blocks

Now that we have an idea of what Progressive Web Apps are, let's take a look at their core building blocks, or the core techniques and technologies we need to use to build a PWA.

## Service Workers

Service workers are basically JavaScript code that runs in a background process, separately from the main browser thread, even if the application is not open in the browser. It is a technology well supported by modern web browsers [2](https://caniuse.com/#feat=serviceworkers) and a building block that provides a lot of the features that PWAs can provide.

Service workers can intercept network requests and cache those requests to improve performance. This cache can then also be used to provide offline access when the network is not available [[3](https://developers.google.com/web/ilt/pwa/introduction-to-service-worker)].

Because they run in the background, they are capable of providing some features that make web applications work like native apps, such as:

* Background Sync
* Push Notifications

### Other Characteristics

There are a couple more characteristics to service workers that are consequences of their role in a PWA and the fact that they are independent from the application they are associated with:

* Because a service worker is not blocking, synchronous XHR and localStorage cannot be used.
* Service workers can't access the DOM directly, so they need to use a messaging system to communicate with the page.
* As they can intercept network requests and modify responses, service workers only run over HTTPS to prevent "man-in-the-middle" attacks.
* Service workers become idle when not in use and restart when needed.

## Web App Manifests

A web app manifest makes it possible for a web application to be added to mobile device homescreens. It is a simple JSON file that also describes how it should behave when "installed". Among other things, it specifies the icon to be used, the URL to access when the app is launched and the background color of the splash screen displayed while the app is loading.

## Responsive Design

At this point, responsive web design is a topic that does not need introduction, but it can be considered a core bulding block of PWAs because one of the goals is to create an application that fits any form factor [[4](https://developers.google.com/web/fundamentals/codelabs/your-first-pwapp/)].

# PWAs and SPAs (Single Page Applications)

There's one important confusion that is frequently seen regarding SPAs and PWAs, that the techniques and technologies to progressively enhance web applications to turn them into PWAs can only be applied to single page applications. The reality is that any web application can become a progressive web app no matter it is a SPA or a traditional multiple pages application.

# The Web App Manifest

A web app manifest is a JSON file that describes how a web app should behave once it is "installed" in the user's device. For example, the browser uses that information to determine the icon to display when the application is added to the device's homescreen.

# Adding a Manifest File

Adding a manifest file to a project is as simple as creating a file named `manifest.json` and linking it in the `<head>` of all the pages of the web app:

{% highlight html %}
<link rel="manifest" href="/manifest.json">
{% endhighlight %}

# Content of the Manifest File

Below, there's an example content for an application manifest file:

{% highlight json %}
{
  "name": "Progressive Journal",
  "short_name": "pJournal",
  "start_url": "index.html",
  "scope": ".",
  "display": "standalone",
  "background_color": "#ee6e73",
  "theme_color": "#ee6e73",
  "description": "A travel journal app created to study about Progressive Web Apps",
  "dir": "ltr",
  "lang": "en-US",
  "orientation": "portrait",
  "icons": [
    {
      "src": "/src/images/icons/progressive-journal-icon-36x36.png",
      "type": "image/png",
      "sizes": "36x36"
    },
    {
      "src": "/src/images/icons/progressive-journal-icon-144x144.png",
      "type": "image/png",
      "sizes": "144x144"
    }
  ],
  "related_applications": [
    {
      "platform": "play",
      "url": "https://play.google.com/store/apps/details?id=com.example.app1",
      "id": "com.example.app1"
    },
    {
      "platform": "itunes",
      "url": "https://itunes.apple.com/app/example-app1/id123456789"
    }
  ]
}
{% endhighlight %}

* `name`: specifies a long name for the app, displayed in the app install prompt[[5](https://developers.google.com/web/fundamentals/web-app-manifest/)], for example.
* `short_name`: short name for the app that may be used, for example, in a device homescreen where there is insufficient space to display the full name.
* `start_url`: URL that is loaded when the app is launched through the icon added to the homescreen.
* `scope`: determines the pages the web app manifest applies to. "." applies to all pages.
* `display`: defines the preferred display mode for the website [[6](https://developer.mozilla.org/en-US/docs/Web/Manifest#display)]. Using `standalone` will make the app look and feel like a standalone app, for example.

![PWA display modes: browser, standalone, fullscreen](/assets/images/blog/pwa-introduction-part1-pwa_display_modes.png)
*A PWA launched `browser` mode (left), `standalone` mode (middle) and `fullscreen` mode (right). Image: [New in Chrome 58](https://developers.google.com/web/updates/2017/04/nic58)*

* `background_color`: sets the background color used in the splashscreen displayed while the app is loading.
* `theme_color`: this color is shown, for example, in the browser toolbar and in the top bar on Android's task switcher, what increases the sense of OS integration even more.
* `description`: this field is used whenever the browser needs some description for an app.
* `dir`: specifies the text direction for `name`, `short_name` and `description`.
* `lang`: together with lang, it helps to display right-to-left languages.
* `orientation`: sets the default orientation, but bear in mind users prefer selecting the orientation themselves.

![PWA display display orientations: portrait, landscape](/assets/images/blog/pwa-introduction-part1-pwa_orientation_modes.png)
*Portrait and landscape orientation options for the web app manifest. Image:[The Web App Manifest](https://developers.google.com/web/fundamentals/web-app-manifest/?hl=ja)*

* `icons`: icons to be displayed in the homescreen. Multiple icons with different sizes can be provided in the array and the browser will determine the "best" icon depending on the device.
* `related_applications`: array of native applications that can be installed through the applications stores of the respective platforms.

# Conclusion

In this first part of the series about the course on PWAs I am taking on Udemy, I tried to define what Progressive Web apps are, presented their building blocks and an introduction to web app manifests. In the next part, we are going to go deeper into the subject of web app manifests and start talking about service workers.

# References

1. [Progressive Web Apps - Google Developers](https://developers.google.com/web/progressive-web-apps/)
2. [Service Workers - Can I use](https://caniuse.com/#feat=serviceworkers)
3. [Introduction to Service Worker - Google Developers](https://developers.google.com/web/ilt/pwa/introduction-to-service-worker)
4. [Your First Progressive Web App](https://developers.google.com/web/fundamentals/codelabs/your-first-pwapp/)
5. [The Web App Manifest - Google Developers](https://developers.google.com/web/fundamentals/web-app-manifest/)
6. [Web App Manifest #display - MDN](https://developer.mozilla.org/en-US/docs/Web/Manifest#display)
