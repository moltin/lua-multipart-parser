# lua-multipart

A Lua library to parse `multipart/form-data` data.

# Usage

```
local multipart = require "multipart"
local multipart_data = multipart()
local data = multipart_data:get()
```

This is an example of the headers for a multipart/form-data request that will be processed by our library

```
--- more_headers
Content-Type: multipart/form-data; boundary=---------------------------820127721219505131303151179
--- request eval
qq{POST /t\n-----------------------------820127721219505131303151179\r
Content-Disposition: form-data; name="file1"; filename="a.txt"\r
Content-Type: text/plain\r
\r
Hello, world\r\n-----------------------------820127721219505131303151179\r
Content-Disposition: form-data; name="test"\r
\r
value\r
\r\n-----------------------------820127721219505131303151179--\r
}
```

# Contribute
