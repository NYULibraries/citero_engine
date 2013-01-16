CiteroEngine Engine Gem
======================
[![Build Status](https://secure.travis-ci.org/NYULibraries/citero_engineEngineGem.png)](http://travis-ci.org/NYULibraries/citero_engineEngineGem)


A JRuby wrapper for the CiteroEngine tool, enables use of the citero_engine tool in JRuby distributed as a Rails 3 Engine Gem.

Install
==========

Mount the engine gem to your rails project like so:

```ruby
mount CiteroEngine::Engine, :at => '/MOUNT_NAME'
```

Formats supported
========
Currently supporting PNX, RIS, CSF, BiBTeX, OpenURL.


How to use
========

There are two methods to use this engine. To use the ActiveRecord method, first you must have a record. You can create one by issuing a POST to MOUNT\_NAME/records with the parameters _data_ as the raw data, _from_ as the initial formatting, and _ttl_ as the records title.

To translate the record, simply go to MOUNT\_NAME/cite/id?format=someformat where _id_ is the active record title and _format_ is the output format.
Similarly one can go to MOUNT\_NAME/cite?format=someformat&_OPENURL_ to use OpenURL translation without a record. 

To translate without a record, simply send a POST request to MOUNT\_NAME/translate with parameters _data_, the raw data, _data_, incoming format and _to_, output format, set. You can also send a GET to MOUNT\_NAME/translate/data/from/to as well. Be sure to urlencode all values.