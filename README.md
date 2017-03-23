ExCite Engine Gem
======================
[![Build Status](http://jenkins.library.nyu.edu/buildStatus/icon?job=ex_cite Staging Test)](http://jenkins.library.nyu.edu/view/Citero/job/ex_cite%20Staging%20Test/)
[![Build Status](https://travis-ci.org/NYULibraries/ex_cite.png?branch=master)](https://travis-ci.org/NYULibraries/ex_cite)
[![CircleCI](https://circleci.com/gh/NYULibraries/ex_cite.svg?style=svg)](https://circleci.com/gh/NYULibraries/ex_cite)
[![Coverage Status](https://coveralls.io/repos/NYULibraries/ex_cite/badge.png?branch=master)](https://coveralls.io/r/NYULibraries/ex_cite?branch=master)
[![Dependency Status](https://gemnasium.com/NYULibraries/ex_cite.png)](https://gemnasium.com/NYULibraries/ex_cite)
[![Gem Version](https://badge.fury.io/rb/ex_cite.png)](http://badge.fury.io/rb/ex_cite)
[![Code Climate](https://codeclimate.com/github/NYULibraries/ex_cite.png)](https://codeclimate.com/github/NYULibraries/ex_cite)

A JRuby wrapper for the citero tool, enables use of the citero tool in JRuby distributed as a Rails 3 Engine Gem.

Install
==========

Mount the engine gem to your rails project like so:

```ruby
mount ExCite::Engine, :at => '/MOUNT_LOCATION'
```

You'll need to require the [jquery-rails](https://github.com/rails/jquery-rails) gem also.

In your Gemfile

```ruby
gem "jquery-rails"
```

Formats supported
========
Currently supporting PNX, RIS, CSF, BiBTeX, OpenURL, XERXES_XML, and EasyBib JSON.

Currently supports the following services RefWorks, EasyBib, EndNote.


How to use
========

There are two methods to use this engine. To use the ActiveRecord method, first you must have a record that implements acts\_as\_citable.  

Otherwise, you can POST or GET to /MOUNT\_LOCATION/export_citations(/:to_format)(/:id) with the parameters data[] and from\_format[] defined.
The data[] array and the from\_format[] array must correspond to each other, that is, each element, e, in data[] is of from\_format format[e].

Finally, you can send an OpenURL request, simply define the :to_format and pass in the query string.

Services
========

Some services, such as Endnote, RefWorks, and EasyBib are already included in ex_cite. These services are configurable right out of the box for your needs.

There are two ways to use services, rendering and redirect. The render method will render a view with a 200 response, and the redirect will, as expected,
redirect to another page with a 302 response.

To configure a built-in service, such as Endnote, Refworks, or EasyBib, simply modify the following objects

```ruby
ExCite.easybib
ExCite.refworks
ExCite.endnote
```

The available options are as follow, with available defaults shown

```ruby
:name				=> 	'Service' # What you want to call this service, and how it will be accessed, i.e. 'easybibpush'
:to_format			=>	# The format that the service is expecting
:action				=>	'render' # Either :redirect or :render is supported
:template			=>	'ex_cite/cite/external_form' # The template view to render. You are free to use your own, ex_cite provides one for free!
:url				=>	# The url to redirect to or the url to send the form to
:method				=>	'POST' # This is the form action
:enctype			=>	'application/x-www-form-urlencoded' # This is the enctype for the form
:element_name		=> 	'data' # The default view constructs a form that automatically posts, this is the name of the textbox.
:callback_protocol	=>	:http # The protocol the callback url is to use for this application. Defaults to :http, supports :https

alias :protocol :callback_protocol	# An alias, should you wish to use this outdated version.
```
To add a new service, simply

```ruby
easybib = PushFormat.new( :name => :easybibpush, :to_format => :easybib, :action => :render, :template => "ex_cite/cite/external_form", :url => "http://www.easybib.com/cite/bulk")
ExCite.push_formats['easybib'] = easybib
```
Examples
========

Mounted at root (/)

    GET, POST (ActiveRecord, will download RIS)
    http://localhost:3000/export_citations?to_format=ris&id[]=1
    http://localhost:3000/export_citations/ris/1

    GET, POST (ActiveRecord, will push to refworks)
    http://localhost:3000/export_citations?to_format=refworks&id[]=1
    http://localhost:3000/export_citations/refworks/1

    GET, POST (Non ActiveRecord, will download RIS)
    http://localhost:3000/export_citations?to_format=ris&from_format[]=csf&from_format[]=csf&data[]=itemType%3A%20book&data[]=itemType%3A%20journalArticle
    GET, POST (Non ActiveRecord, will push to refworks)
    http://localhost:3000/export_citations?to_format=refworks&from_format[]=csf&from_format[]=csf&data[]=itemType%3A%20book&data[]=itemType%3A%20journalArticle

    OpenURL (Non ActiveRecord, will download RIS)
    http://localhost:3000/export_citations?to_format=ris&url_ver=Z39.88-2004&url_ctx_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Actx&ctx_ver=Z39.88-2004&ctx_tim=2012-11-20T13%3A40%3A11-05%3A00&ctx_id=&ctx_enc=info%3Aofi%2Fenc%3AUTF-8&rft.genre=journal&rft.issn=0893-3456&rft.jtitle=Los+Alamos+monitor&rft.language=eng&rft.object_id=991042747005504&rft.object_type=JOURNAL&rft.page=1&rft.place=Los+Alamos%2C+N.M.&rft.pub=%5BH.+Markley+McMahon%5D&rft.stitle=ALAMOS+MONITOR+%28LOS+ALAMOS%2C+NM%29&rft.title=Los+Alamos+monitor&rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&rft_id=L&req.ip=127.0.0.1
    OpenURL (Non AciveRecord, will push to refworks)
    http://localhost:3000/export_citations?to_format=refworks&url_ver=Z39.88-2004&url_ctx_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Actx&ctx_ver=Z39.88-2004&ctx_tim=2012-11-20T13%3A40%3A11-05%3A00&ctx_id=&ctx_enc=info%3Aofi%2Fenc%3AUTF-8&rft.genre=journal&rft.issn=0893-3456&rft.jtitle=Los+Alamos+monitor&rft.language=eng&rft.object_id=991042747005504&rft.object_type=JOURNAL&rft.page=1&rft.place=Los+Alamos%2C+N.M.&rft.pub=%5BH.+Markley+McMahon%5D&rft.stitle=ALAMOS+MONITOR+%28LOS+ALAMOS%2C+NM%29&rft.title=Los+Alamos+monitor&rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&rft_id=L&req.ip=127.0.0.1
