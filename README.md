# URL

Create, manipulate and generate URLs.

```v
module main

import khalyomede.url { Url }

fn main() {
  link := Url.parse("https://example.com/contact?theme=dark#twitter")!

  assert link.host == "example.com"
  assert link.path == "/contact"
}
```

## Summary

- [About](#about)
- [Features](#features)
- [Installation](#installation)
- [Examples](#examples)

## About

I created this library to be able to parse URLs so that my router can react to the correct routes.

It can be used for a wide range of use cases, such as generating valid URLs given a set of basic information (like the scheme and the host) using a chain of methods.

[back to summary](#summary)

## Features

- Can parse an URL
- Can generate an URL
- Can chain methods to modify an URL
- Supports fragments, queries and ports
- Normalize URLs parts (uppercases scheme/host are always returned lowercase)

[back to summary](#summary)

## Installation

- [Using V installer](#using-v-installer)

### Using V installer

In your terminal, run this command:

```v
v install khalyomede.url
```

[back to summary](#summary)

## Examples

- Parsing
  - [Parse an URL](#parse-an-url)
- Generating
  - [Create a new URL](#create-a-new-url)
- Retrieving
  - [Get the scheme from an URL](#get-the-scheme-from-an-url)
  - [Get the port from an URL](#get-the-port-from-an-url)
  - [Get the host from an URL](#get-the-host-from-an-url)
  - [Get the path from an URL](#get-the-path-from-an-url)
  - [Get a query string by key from an URL](#get-a-query-string-by-key-from-an-url)
  - [Get the original raw query string](#get-the-raw-original-query-string)
  - [Get the fragment from an URL](#get-the-fragment-from-an-url)
- Comparing
  - [Compare two URLs are equivalent](#comparing-two-urls-are-equivalent)
- Casting
  - [Rendering your Url as a string](#rendering-your-url-as-a-string)

### Parse an URL

```v
module main

import khalyomede.url { Url }

fn main() {
  link := Url.parse("https://example.com")!
}
```

URLs are automatically decoded when parsing them.

```v
module main

import khalyomede.url { Url }

fn main() {
  link := Url.parse("https://example.com/contact?subject=Sales%20order")

  assert link.query["subject"] or { "" } == "Sales order"
}
```

Note that when the URL is not valid (meaning it does not have at least a scheme and a domain), you should handle this Error.

This means **relatives URL** are not permitted using this library (contrary to the built-in net.urllib module).

```v
module main

import khalyomede.url { Url }

fn main() {
  link := Url.parse("example.com/contact-us") or {
    assert err.str() == "The scheme is missing."

    panic(err)
  }
}
```

You can perform fine grained error handling if you prefer.

```v
module main

import khalyomede.url { Url, MissingScheme, MissingDomain, TraversingAboveRoot, BadlyEncodedPath, BadlyEncodedFragment, BadlyEncodedQuery }

fn main() {
  link := Url.parse("contact-us") or {
    error_message := match err {
      MissingScheme { "The scheme is missing" }
      MissingDomain { "The domain is missing" }
      TraversingAboveRoot { "Trying to go above root" }
      BadlyEncodedPath { "The path is not well encoded" }
      BadlyEncodedFragment { "The fragment is not well encoded" }
      BadlyEncodedQuery { "The query is not well encoded" }
    }

    panic(error_message + " (${err}).")
  }
}
```

When an URL contains relative accessors (".", ".."), the absolute URL is resolved.

```v
module main

import khalyomede.url { Url }

fn main() {
  link := Url.parse("https://example.com/user/1/../create")!

  assert link.str() == "https://example.com/user/create"
}
```

Doubles slashes are automatically simplified.

```v
module main

import khalyomede.url { Url }

fn main() {
  link := Url.parse("https://example.com/user//create//")!

  assert link.str() == "https://example.com/user/create/"
}
```

This library automatically strips any ending slashes, for consistancy.

```v
module main

import khalyomede.url { Url }

fn main() {
  link := Url.parse("https://example.com/settings/")

  assert link.str() == "https://example.com/settings"
}
```

Lastly, you can get the originally parsed url.

```v
module main

fn main() {
  link := Url.parse("HTTPS://example.com");

  assert link.str() == "https://example.com"
  assert link.original == "HTTPS://example.com"
}
```

[back to examples](#examples)

### Create a new URL

You need to specify at least the scheme and domain when creating a new URL.

```v
module main

import khalyomede.url { Url, Https }

fn main() {
  link := Url{
    scheme: Https{}
    domain: "example.com"
  }
}
```

You are free to specify more information if want.

```v
module main

import khalyomede.url { Url, Https }

fn main() {
  link := Url{
    scheme: Https{}
    domain: "example.com"
    path: "contact-us"
    port: 8080 // port is a ?u16
    query: {
      "lang": "fr"
      "theme": "dark"
    }
    fragment: "whatsapp"
  }

  assert link.str() == "https://example.com/contact-us?lang=fr&theme=dark#whatsapp"
}
```

The `Url` struct is immutable. If you want to change one component of your url, use this syntax:

```v
module main

import khalyomede.url { Url, Https }

fn main() {
  mut link := Url{
    scheme: Https{}
    domain: "example.com"
  }

  link = Url{
    ...link
    query: {
      lang: "es"
    }
  }

  assert link.query["lang"] or { "en" } == "es"
}
```

[back to examples](#examples)

### Get the scheme from an URL

You get a `Scheme` type (which is a sum type of all possible schemes). You can also convert it to a string.

```v
module main

import khalyomede.url { Url, Https }

fn main() {
  link := Url.parse("https://example.com")

  assert link.scheme == Https{}
  assert link.scheme.str() == "https"
}
```

Note that when the scheme is not listed among the common ones (`Http{}`, `Https{}`, ...), the struct will be `Other{}`

```v
module main

import khalyomede.url { Url, Other }

fn main() {
  link := Url.parse("facebook://user/johndoe")

  assert link.scheme == Other{ value: "facebook" }
  assert link.scheme.str() == "facebook"
}
```

You can match over all different schemes if you need it:

```v
module main

import khalyomede.url { Url, Http, Https, Ftp, Ftps, Ssh, Git, File, Other }

fn main() {
  link := Url.parse("facebook://user/johndoe")

  message := match link.scheme {
    Http { "Url is HTTP" }
    Https { "Url is HTTPS" }
    Ftp { "Url is FTP" }
    Ftps { "Url is FTPS" }
    Ssh { "Url is SSH" }
    Git { "Url is Git" }
    File { "Url is file" }
    Other { "Url is other (${link.scheme.value})" }
  }

  assert message == "Url is other (facebook)"
}
```

[back to examples](#examples)

### Get the port from an URL

```v
module main

import khalyomede.url { Url }

fn main() {
  link := Url.parse("http://localhost:1234");

  assert link.port or { 80 } == 1234
}
```

Note that when there is no port, the value will be the one provided as a default when handling the Option value.

```v
module main

import khalyomede.url { Url }

fn main() {
  link := Url.parse("https://example.com");

  assert link.port or { 80 } == 80
}
```

[back to examples](#examples)

### Get the host from an URL

```v
module main

import khalyomede.url { Url }

fn main() {
  link := Url.parse("https://example.com")

  assert lunk.host == "example.com"
}
```

[back to examples](#examples)

### Get the path from an URL

```v
module import

import khalyomede.url { Url }

fn main() {
  link := Url.parse("https://example.com/settings/notifications");

  assert link.path == "/settings/notifications"
}
```

Note that query strings and fragments are ignored.

```v
module import

import khalyomede.url { Url }

fn main() {
  link := Url.parse("https://example.com/contact?lang=fr#slack");

  assert link.path == "/contact"
}
```

Also, when the path is empty (root of the domain), the returned path will be "/". Keep in mind the path always starts with a leading slash.

```v
module main

import khalyomede.url { Url }

fn main() {
  link := Url.parse("https://example.com");

  assert link.path == "/"
}
```

[back to examples](#examples)

### Get a query string by key from an URL

```v
module main

import khalyomede.url { Url }

fn main() {
  link := Url.parse("https://example.com?lang=fr");

  assert link.query["lang"] or { "en" } == "fr"
}
```

Note that if there is duplicate keys, only the last value will be preserved during parsing.

```v
module main

import khalyomede.url { Url }

fn main() {
  link := Url.parse("https://example.com?lang=fr&lang=en");

  assert link.query["lang"] or { "en" } == "en"
}
```

This library does not support multi-level queries (for example, "filter[name]=john") since it has not been standardized.

Instead, we advise you use JSON for complex/multi-level values.

```v
module main

import khalyomede.url { Url }
import json

struct Filter {
  name ?string
}

fn main() {
  link := Url.parse('https://example.com/users?filter={"name":"john"}')

  raw_filter := link.query["filter"] or { '{}' }
  filter := json.decode(Filter, raw_filter)!

  assert filter.name or { "" } == "john"
}
```

[back to examples](#examples)

### Get the raw original query string

```v
module main

import khalyomede.url { Url }
import net.urllib { query_unescape }

fn main() {
  link := Url.parse("https://example.com?search=V%20lang")

  assert link.raw_query == "search=V%20lang"
  assert query_unescape(link.raw_query) == "search=V lang"
}
```

[back to examples](#examples)

### Get the fragment from an URL

```v
module main

fn main() {
  link := Url.parse("https://example.com/contact#whatsapp");

  assert link.fragment == "whatsapp"
}
```

[back to examples](#examples)

### Compare two URLs are equivalent

Comparing two `url` by casting them to string may lead to false positives.

In one hand, consider cases when the scheme is one time in uppercase, another time in lowercase.

In another hand, think about scheme default ports. For example, you may have one time an URL that specify the port (https://example.com:443/contact-us) and another time no (https://example.com/contact-us). In this case they are also equivalent, since HTTPS default port is 443.

For handling these edge cases, you can use this method.

```v
module main

import khalyomede.url { Url }

fn main() {
  first_link := Url.parse("https://example.com:443");
  second_link := Url.parse("HTTPS://example.com");

  assert first_link.is_equivalent_to(second_link)
}
```

### Rendering your Url as a string

URLs are automatically encoded when casted to string.

```v
module main

import khalyomede.url { Url, Https }

fn main() {
  link := Url{
    scheme: Https{}
    domain: "example.com"
    path: "contact"
    query: {
      "subject": "Sales order"
    }
  }

  assert link.str() == "https://example.com/contact?subject=Sales%20order"
}
```
