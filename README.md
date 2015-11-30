# lua-multipart-parser

A Lua library to parse `multipart/form-data` data.

# Usage

```
local multipart = require "multipart"
local multipart_data = multipart()
local data = multipart_data:get()
```

And that's how our data will looks like after being parsed if we do the following request:

![](http://blog.zot24.com/content/images/2015/11/Screen-Shot-2015-11-25-at-14-40-44.png)

```
{
  param1 = "data1",
  param2 = "data2",
  param3 = "data3"
}
```

# Contribute

* Fork it the repository
* Create your feature branch (git checkout -b my-new-feature)
* Commit your changes (git commit -am 'Add some feature')
* Push to the branch (git push origin my-new-feature)
* Create a new Pull Request