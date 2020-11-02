---
layout: post
title:  "Creating a Portfolio Website with Jekyll (and Hosting it on GitHub) - Part 1"
date:   2018-07-14 22:16:58 +0900
---

# Repository Creation



# Jekyll Installation

In this article, I won't cover the installation process. It is very well documented in the [Jekyll documentation](https://jekyllrb.com/docs/installation/) and I assume you are going to follow that, but I will try to present some guidelines. I also assume you have a working Git installation.

Jekyll is distributed as a [Ruby Gem](https://guides.rubygems.org/rubygems-basics/) and can be installed on most systems. It is recommended to work on a Unix-based system such as macOS or Linux, but you should not have problems working on Windows as well. By the way, this article was written on a Windows machine with Windows Subsystem for Linux enabled. You can take a look at the [official documentation](https://jekyllrb.com/docs/windows/#installation-via-bash-on-windows-10) if you choose to go this path too.

Whatever system you choose to work on, the requirements are the same. You are going to need to have Ruby, RubyGems and build tools (GCC and Make) installed. If you, like me, are a Rails developer and already have a Ruby development environment installed, you should be good to go after installing Jekyll with the following commands (we are also installing bundler, a gem that helps us manage other Ruby gems in our project):

{% highlight shell %}
$ gem install jekyll bundler
{% endhighlight %}

# New Project

Now, we are going to create a new Jekyll project:

{% highlight shell %}
$ jekyll new dennistanaka.github.io --skip-bundle
{% endhighlight %}

We passed the option ```--skip-bundle``` because we don't want to install our dependencies system-wide. Instead, we want the installation of our dependencies to be limited to our project. But first, as we know we are going to host our website on GitHub, we want to setup up our project accordingly. First, open the Gemfile file created on your project's root folder.

And remove the line declaring the dependency of the jekyll gem. It may differ depending on the version of the software you are working with, but in my case, I removed the following line:

{% highlight ruby %}
gem "jekyll", "~> 3.6.2"
{% endhighlight %}

And uncomment the following line:

{% highlight ruby %}
# gem "github-pages", group: :jekyll_plugins
{% endhighlight %}

# Dependencies Installation

We can now install or dependencies locally with the following command:

{% highlight shell %}
$ cd dennistanaka.github.io
$ bundle install --path vendor/bundle
{% endhighlight %}

# Local Server Startup

After that we can serve our website with the following command:

{% highlight shell %}
$ bundle exec jekyll serve
{% endhighlight %}

Just open a browser and access the following address:

```
http://127.0.0.1:4000/
```

Great! We already have a working website. You can see Jekyll comes with a pre-defined look & feel. Jekyll supports themes and it uses a theme called minima by default. You can check this fact by opening the Gemfile file, where there is a line setting the minima gem as a dependency:

{% highlight ruby %}
gem "minima", "~> 2.0"
{% endhighlight %}

In this article, I will show you how we can start customizing our website. Although we can start our website from scratch, without a theme at all, it is probably easier to have a starting point, at least when using Jekyll for the first time.

But, before that, let's add our website to GitHub to manage the changes in our website. You will see that, in the case of a Jekyll website, adding the project to GitHub not only means that we are controlling its versions, but also means that we are deploying our website for public access.

Before doing that, let's edit our .gitignore file. The Jekyll project already comes with a .gitignore to prevent unnecessary files to be commited. But, as installing the gems locally is an optional step, it does not include entries to ignore the installed packages. So, let's add the following lines to the .gitignore file:

```
.bundle
vendor
```

Now we can push our files to GitHub as usual:

{% highlight shell %}
$ git init
$ git add .
$ git commit -m "First commit"
$ git remote add origin git@github.com:dennistanaka/dennistanaka.github.io.git
$ git push -u origin master
{% endhighlight %}

You can now access your website at the URL provided by GitHub. In my case, it is: https://dennistanaka.github.io/. If you still can't see your website, it may take some time for GitHub to build it.


