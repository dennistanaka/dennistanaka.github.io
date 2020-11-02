---
layout: post
title:  "Creating a Portfolio Website with Jekyll (and Hosting it on GitHub) - Part 2"
date:   2019-03-21 20:31:46 +0900
---

In [Part 1](/2018/07/14/portfolio-with-jekyll-part1.html), we took a quick look at Jekyll and how to create and deploy a website to GitHub Pages. In this second and final part, let's explore some of the customization features Jekyll provides us.

# Layouts

In the previous example, you may have noticed the layout definition below in the `front matter`:

{% highlight markdown %}
layout: post
{% endhighlight %}

While the markdown file provides the content of a page, the structure and appearance are defined in the layout file. We can create our own layout files, but because we are using an existing theme, we can customize the theme's layout files instead.

First, let's copy the layout files from the theme's folder to our project (the specific folder to copy from will probably be different for you as it depends on the version of the packages installed).

{% highlight bash %}
cp -r vendor/bundle/ruby/2.3.0/gems/minima-2.5.0/_layouts .
{% endhighlight %}

If we take a look at the _layouts folder, we can see the 4 files below:

* default.html
* home.html
* page.html
* post.html

If we open the `default.html` file, we can see contents like the below:

{% highlight html %}
{% raw %}
<!DOCTYPE html>
<html lang="{{ page.lang | default: site.lang | default: "en" }}">

  {%- include head.html -%}

  <body>

    {%- include header.html -%}

    <main class="page-content" aria-label="Content">
      <div class="wrapper">
        {{ content }}
      </div>
    </main>

    {%- include footer.html -%}

  </body>

</html>
{% endraw %}
{% endhighlight %}

It is an ordinary HTML file, but we can see a couple of the features provided by Jekyll and the Liquid template language it uses.

"Include" tags, like the below, allow us to include content from another file stored in the `_includes` folder:

{% highlight liquid %}
{% raw %}
{%- include header.html -%}
{% endraw %}
{% endhighlight %}

While the line below specifies where the content of a markdown file that uses the layout file will be injected:

{% highlight html %}
{% raw %}
{{ content }}
{% endraw %}
{% endhighlight %}

If we take a look at the contents of `page.html`:

{% highlight html %}
{% raw %}
---
layout: default
---
<article class="post">

  <header class="post-header">
    <h1 class="post-title">{{ page.title | escape }}</h1>
  </header>

  <div class="post-content">
    {{ content }}
  </div>

</article>
{% endraw %}
{% endhighlight %}

We can see that a layout itself can use another layout and that this layout can be used to display an article with a title in the top.

Now, we can also open the `about.md` file that ships with Jekyll. We can see in the `front matter` that this file uses the `page` layout.

{% highlight markdown %}
---
layout: page
title: About
permalink: /about/
---
{% endhighlight %}

Also, the `front matter` defines a title and this title is injected in the line below in the `page` layout:

{% highlight html %}
{% raw %}
<h1 class="post-title">{{ page.title | escape }}</h1>
{% endraw %}
{% endhighlight %}

Now that we have an idea of how layouts work, let's customize our website a little bit.

# Includes

In the `default.html` layout file, we can see the line below:

{% highlight liquid %}
{% raw %}
{%- include header.html -%}
{% endraw %}
{% endhighlight %}

Because the `default.html` layout includes the header and all other layouts uses the `default` layout, it is obvious that all pages in our website includes the content in `header.html`.

Let's take a look at the contents of the `header.html` file. Because it is also part of the minima theme, we need to copy this file as well:

{% highlight bash %}
mkdir _includes
cp vendor/bundle/ruby/2.3.0/gems/minima-2.5.0/_includes/header.html _includes
{% endhighlight %}

This include file is responsible for displaying the website header and shows many variables that Jekyll make available for us, as well as filters provided by the Liquid template language.

{% highlight liquid %}
{% raw %}
{%- assign default_paths = site.pages | map: "path" -%}
{% endraw %}
{% endhighlight %}

The line above, for example, shows the `site.pages` variable. It is an array of Jekyll's `Page` variables (you can check the list of attributes a `Page` variable contains in [Page Variables](https://jekyllrb.com/docs/variables/#page-variables)). Any `.html` or `.md` file in the root folder or a new subfolder that contains a `front matter` will be part of the `site.pages` variable. Then, we execute Liquid's [map](https://shopify.github.io/liquid/filters/map/) filter on the `site.pages` to get an array of the paths of those pages.

{% highlight liquid %}
{% raw %}
{%- assign page_paths = site.header_pages | default: default_paths -%}
{% endraw %}
{% endhighlight %}

The next line creates a variable called `page_paths`. It is assigned the value in `site.header_pages`, but can also be assigned the value in `default_paths` in the case the former does not exist, what is possible with the use of Liquid's [default](https://shopify.github.io/liquid/filters/default/) filter. We are going to come back to `site.header_pages` later.

{% highlight liquid %}
{% raw %}
{%- for path in page_paths -%}
  {%- assign my_page = site.pages | where: "path", path | first -%}
  {%- if my_page.title -%}
  <a class="page-link" href="{{ my_page.url | relative_url }}">{{ my_page.title | escape }}</a>
  {%- endif -%}
{%- endfor -%}
{% endraw %}
{% endhighlight %}

This last snippet iterates over the `page_paths` variable created before and creates a link in the header for each page that has a title (defined in the `front matter`).

To test what was just shown, let's create a new page `notes.md` in the project's root folder. Now, let's add the content below to the new file:

{% highlight markdown %}
---
layout: page
title: Notes
permalink: /notes/
---
{% endhighlight %}

If we refresh our website, we are going to see a new "Notes" link in the header. Add another page called `contact.md` to the root folder with the content below:

{% highlight markdown %}
---
layout: page
title: Contact
permalink: /contact/
---
{% endhighlight %}

A new link is created as well. The problem is that the links are created in the alphabetical order, but we may want a different order to put the "Contact" page last, for example. In that case, we can use the `site.header_pages` mentioned before. This currently does not exist, but we can easily create this variable by adding the following lines to the `_config.yml` file:

{% highlight yml %}
header_pages:
  - about.md
  - notes.md
  - contact.md
{% endhighlight %}

You will notice the change will not be reflected immediately and will require the server to be restarted. After that, the header will look as expected.

{: .center}
![The Resulting Header](/assets/images/blog/jekyll-part2-configured_header.png){:width="600px"}

{: .center}
*The Resulting Header*

# Collections

Now, we are going to explore [Collections](https://jekyllrb.com/docs/collections/) that are a great way to group related content. Let's use this feature to implement the "Notes" section in our website.

First, add the following content to `_config.yml`:

{% highlight yml %}
collections:
  - notes
{% endhighlight %}

Then, let's create a `_notes` folder and add 2 files in it. The `/_notes/note1.md`:

{% highlight markdown %}
---
menu_title: Note 1 Menu Item
title: Note 1 Title
---

Note 1 content

> A nice blockquote

A **formatted** line of *text*.
{% endhighlight %}

And the `/_notes/note2.md`:

{% highlight markdown %}
---
menu_title: Note 2 Menu Item
title: Note 2 Title
---

Note 2 content

> A nice blockquote

A **formatted** line of *text*.
{% endhighlight %}

Now, let's create a custom layout listing all our notes. It will be the `/_layouts/note.html` file and will contain the following content:

```html{% raw %}
---
layout: default
---
<style>
.note {
  margin: 2rem 0;
  padding: 1rem 2rem;
}

.yellow {
  background-color: #fdf475;
}

.blue {
  background-color: #cbf0f8;
}

.note-date {
  font-size: 0.8rem;
  font-style: italic;
  color: gray;
}
</style>
<div class="notes-container">

  <header class="notes-header">
    <h1 class="notes-title">{{ page.title | escape }}</h1>
  </header>

  {%- for note in site.notes -%}
  <article class="note {{ note.background }}">

    <header class="note-header">
      <h2 class="note-title">{{ note.title | escape }}</h2>
      <p class="note-date">{{ note.date }}</p>
    </header>

    <div class="note-content">
      {{ note.content }}
    </div>

  </article>
  {%- endfor -%}
</div>
{% endraw %}```

I added the styles directly in the layout, to keep things simple, as that is not the main focus of the article. As Jekyll has built-in support for Sass, please refer to the [Docs](https://jekyllrb.com/docs/assets/) to know how to manage your stylesheets.

You can see we were able to access our notes through the `site.notes` variable and even use a custom variable `background` we added to the `front matter`.

Restart the server and we can now access those notes in the `/notes/` path.

![The Notes Page](/assets/images/blog/jekyll-part2-notes_page.png){:width="600px"}

*The Notes Page*

The files we created in the `_notes` folder does not generate corresponding files in Jekyll's build process. If you need, you can change this behavior as shown in [Add content](https://jekyllrb.com/docs/collections/#add-content). This would generate files such as `/_notes/note1.html` in the build output. In our example, we could, for example, display only part of the content of the notes in the list and link each note to a page where the user can see their whole content.

# Data Files

In this final section, we are going to take a quick look at [Data Files](https://jekyllrb.com/docs/datafiles/). It allows us to create files with custom data to be used in our templates. Those can be YAML, JSON, or CSV files. Let's do an example to illustrate its use.

First, create a file named `/_data/contacts.yml`:

{% highlight yml %}
- type: Email
  value: me@dennistanaka.com

- type: Phone
  value: (00) 0000-0000

- type: Website
  value: http://github.com/dennistanaka
{% endhighlight %}

This is enough to make our data accessible in our templates in the `site.data.contacts` variable. So, we can now edit our `/contact.md` file with the following content:

{% highlight liquid %}
{% raw %}
---
layout: page
title: Contact
permalink: /contact/
---

<table>
  {%- for contact in site.data.contacts %}
  <tr>
    <td>{{ contact.type }}</td>
    <td>{{ contact.value }}</td>
  </tr>
  {%- endfor %}
</table>
{% endraw %}
{% endhighlight %}

This will generate the below output:

![The Contact Page](/assets/images/blog/jekyll-part2-contact_page.png){:width="600px"}

*The Contact Page*

As we could see, we can use `Data Files` to remove repetition in our pages by separating data and configuration. A practical use is illustrate in [Navigation](https://jekyllrb.com/tutorials/navigation/) where it is used to create custom navigation for a website.

# Conclusion

In these article, we could learn and practice basic Jekyll concepts such as `Layouts`, `Collections` and `Data Files`. There are plenty of content was not covered in the articles, so I highly recommend reading the documentation, as it is very well written and easy to understand.
