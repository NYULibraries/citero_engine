ExCite Engine Gem
======================
[![Build Status](https://secure.travis-ci.org/NYULibraries/ex_cite.png)](http://travis-ci.org/NYULibraries/ex_cite)


A JRuby wrapper for the citero tool, enables use of the citero tool in JRuby distributed as a Rails 3 Engine Gem.

Install
==========

Mount the engine gem to your rails project like so:

```ruby
mount ExCite::Engine, :at => '/MOUNT_LOCATION'
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
