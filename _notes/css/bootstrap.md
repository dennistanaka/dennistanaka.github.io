---
menu_title: Bootstrap
title: CSS - Bootstrap
permalink: /notes/css/bootstrap/
---

<h4>Table of Contents</h4>
* TOC
{:toc}

## Bullet Points

* Use `.container-fluid` for a full width container, spanning the entire width of the viewport.

## Grid

* Thanks to flexbox, grid columns without a specified width will automatically layout as equal width columns. For example, four instances of .col-sm will each automatically be 25% wide from the small breakpoint and up. See the auto-layout columns section for more examples.
* Column classes indicate the number of columns you’d like to use out of the possible 12 per row. So, if you want three equal-width columns across, you can use .col-4.
* Grid breakpoints are based on minimum width media queries, meaning they apply to that one breakpoint and all those above it (e.g., .col-sm-4 applies to small, medium, large, and extra large devices, but not the first xs breakpoint).

### Grid Options

<table>
  <thead>
    <tr>
      <th></th>
      <th>
        Extra small<br>
        <small>&lt;576px</small>
      </th>
      <th>
        Small<br>
        <small>≥576px</small>
      </th>
      <th>
        Medium<br>
        <small>≥768px</small>
      </th>
      <th>
        Large<br>
        <small>≥992px</small>
      </th>
      <th>
        Extra large<br>
        <small>≥1200px</small>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">Max container width</th>
      <td>None (auto)</td>
      <td>540px</td>
      <td>720px</td>
      <td>960px</td>
      <td>1140px</td>
    </tr>
    <tr>
      <th scope="row">Class prefix</th>
      <td><code>.col-</code></td>
      <td><code>.col-sm-</code></td>
      <td><code>.col-md-</code></td>
      <td><code>.col-lg-</code></td>
      <td><code>.col-xl-</code></td>
    </tr>
    <tr>
      <th scope="row"># of columns</th>
      <td colspan="5">12</td>
    </tr>
    <tr>
      <th scope="row">Gutter width</th>
      <td colspan="5">30px (15px on each side of a column)</td>
    </tr>
    <tr>
      <th scope="row">Nestable</th>
      <td colspan="5">Yes</td>
    </tr>
    <tr>
      <th scope="row">Column ordering</th>
      <td colspan="5">Yes</td>
    </tr>
  </tbody>
</table>

## Media Query - Minimum Widths

{% highlight css %}
// Extra small devices (portrait phones, less than 576px)
// No media query since this is the default in Bootstrap

// Small devices (landscape phones, 576px and up)
@media (min-width: 576px) { ... }

// Medium devices (tablets, 768px and up)
@media (min-width: 768px) { ... }

// Large devices (desktops, 992px and up)
@media (min-width: 992px) { ... }

// Extra large devices (large desktops, 1200px and up)
@media (min-width: 1200px) { ... }
{% endhighlight %}

### Usage

{% highlight css %}
@include media-breakpoint-up(xs) { ... }
@include media-breakpoint-up(sm) { ... }
@include media-breakpoint-up(md) { ... }
@include media-breakpoint-up(lg) { ... }
@include media-breakpoint-up(xl) { ... }

// Example usage:
@include media-breakpoint-up(sm) {
  .some-class {
    display: block;
  }
}
{% endhighlight %}

## Media Query - Maximum Widths

{% highlight css %}
// Extra small devices (portrait phones, less than 576px)
@media (max-width: 575.98px) { ... }

// Small devices (landscape phones, less than 768px)
@media (max-width: 767.98px) { ... }

// Medium devices (tablets, less than 992px)
@media (max-width: 991.98px) { ... }

// Large devices (desktops, less than 1200px)
@media (max-width: 1199.98px) { ... }

// Extra large devices (large desktops)
// No media query since the extra-large breakpoint has no upper bound on its width
{% endhighlight %}

### Usage

{% highlight css %}
@include media-breakpoint-down(xs) { ... }
@include media-breakpoint-down(sm) { ... }
@include media-breakpoint-down(md) { ... }
@include media-breakpoint-down(lg) { ... }
{% endhighlight %}

## Media Query - Between

{% highlight css %}
// Extra small devices (portrait phones, less than 576px)
@media (max-width: 575.98px) { ... }

// Small devices (landscape phones, 576px and up)
@media (min-width: 576px) and (max-width: 767.98px) { ... }

// Medium devices (tablets, 768px and up)
@media (min-width: 768px) and (max-width: 991.98px) { ... }

// Large devices (desktops, 992px and up)
@media (min-width: 992px) and (max-width: 1199.98px) { ... }

// Extra large devices (large desktops, 1200px and up)
@media (min-width: 1200px) { ... }
{% endhighlight %}

### Usage

{% highlight css %}
@include media-breakpoint-only(xs) { ... }
@include media-breakpoint-only(sm) { ... }
@include media-breakpoint-only(md) { ... }
@include media-breakpoint-only(lg) { ... }
@include media-breakpoint-only(xl) { ... }
{% endhighlight %}

### Span Multiple Breakpoint Widths

{% highlight css %}
// Example
// Apply styles starting from medium devices and up to extra large devices
@media (min-width: 768px) and (max-width: 1199.98px) { ... }
{% endhighlight %}

Usage:

{% highlight css %}
@include media-breakpoint-between(md, xl) { ... }
{% endhighlight %}

<span class="info-source">Source: [https://getbootstrap.com/docs/4.2/layout/grid/](https://getbootstrap.com/docs/4.2/layout/grid/)</span>
