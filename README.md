Citation Engine Gem
======================
[![Build Status](https://secure.travis-ci.org/NYULibraries/citationEngineGem.png)](http://travis-ci.org/NYULibraries/citationEngineGem)


A JRuby wrapper for the Citation tool, enables use of the citation tool in JRuby distributed as a Rails 3 Engine Gem.

Install
==========

Mount the engine gem to your rails project like so:

```ruby
mount Citation::Engine, :at => '/MOUNT_NAME'
```

How to use
========

There are two methods to use this engine. To use the ActiveRecord method, first you must create a record by issuing a POST to MOUNT\_NAME/records with the parameters _data_ as the raw data, _from_ as the initial formatting [PNX,RIS,CSF,BiBTeX,OpenURL], and _ttl_ as the records title.

To translate the record, simply go to MOUNT\_NAME/records/_title_/_format_ where _title_ is the active record title and _format_ is the output format.

To translate without a record, simply send a POST request to MOUNT\_NAME/translate with parameters _data_, the raw data, _data_, incoming format and _to_, output format, set. You can also send a GET to MOUNT\_NAME/translate/_data_/_from_/_to_ as well. Be sure to urlencode all values.