---
menu_title: Date & Time
title: JavaScript - Date & Time
permalink: /notes/javascript/datetime/
---

<h4>Table of Contents</h4>
* TOC
{:toc}

## Time Difference - Using Moment.js

{% highlight javascript %}
// example of difference in seconds
const currentTime = moment();
const diff = currentTime.diff(startTime, 'seconds');
{% endhighlight %}

<span class="info-source">Source: [https://momentjs.com/docs/#/displaying/difference/](https://momentjs.com/docs/#/displaying/difference/)</span>
