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

Source: [StackOverflow](https://stackoverflow.com/questions/1197928/how-to-add-30-minutes-to-a-javascript-date-object)<br />
Source: [Moment.js](http://momentjs.com/)
