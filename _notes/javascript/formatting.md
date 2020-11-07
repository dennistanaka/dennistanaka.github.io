---
menu_title: Formatting
title: JavaScript - Formatting
permalink: /notes/javascript/formatting/
---

<h4>Table of Contents</h4>
* TOC
{:toc}

## Thousands Separator

{% highlight javascript %}
// example setting label with JPY price
priceLabel.text(`${price.toLocaleString('ja-JP')}円`);
{% endhighlight %}

<span class="info-source">Source: [https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/toLocaleString](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/toLocaleString)</span>
