module test

import url { Url, Https, MissingDomain, MissingScheme, TraversingAboveRoot, BadlyEncodedFragment, BadlyEncodedPath, BadlyEncodedQuery }

fn test_it_parses_url_with_domain_and_host() {
    link := Url.parse("https://example.com")!

    assert link.scheme is Https
    assert link.host == "example.com"
    assert link.port == none
    assert link.path == "/"
    assert link.segments == []
    assert link.query == map[string]string{}
    assert link.fragment == ""
}

fn test_it_parses_url_with_domain_host_and_port() {
    link := Url.parse("https://example.com:8080")!

    assert link.scheme is Https
    assert link.host == "example.com"
    assert link.port or { 0 } == 8080
    assert link.path == "/"
    assert link.segments == []
    assert link.query == map[string]string{}
    assert link.fragment == ""
}

fn test_it_parses_url_with_domain_host_and_path() {
    link := Url.parse("https://example.com/contact-us")!

    assert link.scheme is Https
    assert link.host == "example.com"
    assert link.port == none
    assert link.path == "/contact-us"
    assert link.segments == ["contact-us"]
    assert link.query == map[string]string{}
    assert link.fragment == ""
}

fn test_it_parses_url_with_domain_host_and_multi_level_path() {
    link := Url.parse("https://example.com/api/v1/users")!

    assert link.scheme is Https
    assert link.host == "example.com"
    assert link.port == none
    assert link.path == "/api/v1/users"
    assert link.segments == ["api", "v1", "users"]
    assert link.query == map[string]string{}
    assert link.fragment == ""
}

fn test_it_parses_url_with_host_domain_and_query() {
    link := Url.parse("https://example.com?search=query")!

    assert link.scheme is Https
    assert link.host == "example.com"
    assert link.port == none
    assert link.path == "/"
    assert link.query == {"search": "query"}
    assert link.fragment == ""
}

fn test_it_parses_url_with_host_domain_and_fragment() {
    link := Url.parse("https://example.com#section1")!

    assert link.scheme is Https  // Fixed typo: was "schemee"
    assert link.host == "example.com"
    assert link.port == none
    assert link.path == "/"
    assert link.query == map[string]string{}
    assert link.fragment == "section1"
}

fn test_it_parses_url_with_host_domain_and_relative_accessor_in_path() {
    link := Url.parse("https://example.com/settings/../contact")!

    assert link.scheme is Https
    assert link.host == "example.com"
    assert link.port == none
    assert link.path == "/contact"
    assert link.segments == ["contact"]
    assert link.query == map[string]string{}
    assert link.fragment == ""
}

fn test_it_parses_url_with_host_domain_and_same_folder_accessor_in_path() {
    link := Url.parse("https://example.com/settings/./profile")!

    assert link.scheme is Https
    assert link.host == "example.com"
    assert link.port == none
    assert link.path == "/settings/profile"
    assert link.segments == ["settings", "profile"]
    assert link.query == map[string]string{}
    assert link.fragment == ""
}

fn test_it_parses_url_with_host_domain_and_double_slashes_in_path() {
    link := Url.parse("https://example.com//settings//profile")!

    assert link.scheme is Https
    assert link.host == "example.com"
    assert link.port == none
    assert link.path == "/settings/profile"
    assert link.segments == ["settings", "profile"]
    assert link.query == map[string]string{}
    assert link.fragment == ""
}

fn test_it_parses_url_with_encoded_path() {
    link := Url.parse("https://example.com/path+with+spaces")!

    assert link.scheme is Https
    assert link.host == "example.com"
    assert link.port == none
    assert link.path == "/path with spaces"
    assert link.segments == ["path with spaces"]
    assert link.query == map[string]string{}
    assert link.fragment == ""
}

fn test_it_parses_url_with_encoded_query() {
    link := Url.parse("https://example.com/path?query=hello%20world#section1")!

    assert link.scheme is Https
    assert link.host == "example.com"
    assert link.port == none
    assert link.path == "/path"
    assert link.segments == ["path"]
    assert link.query == {"query": "hello world"}
    assert link.fragment == "section1"
}

fn test_it_parses_url_with_encoded_fragment() {
    link := Url.parse("https://example.com/path?query=hello#section%201")!

    assert link.scheme is Https
    assert link.host == "example.com"
    assert link.port == none
    assert link.path == "/path"
    assert link.segments == ["path"]
    assert link.query == {"query": "hello"}
    assert link.fragment == "section 1"
}

fn test_it_parses_url_with_encoded_query_string() {
    link := Url.parse("https://example.com/path?query=hello%20world")!

    assert link.scheme is Https
    assert link.host == "example.com"
    assert link.port == none
    assert link.path == "/path"
    assert link.segments == ["path"]
    assert link.query == {"query": "hello world"}
    assert link.fragment == ""
}

fn test_it_parses_uppercase_scheme() {
    link := Url.parse("HTTPS://example.com")!

    assert link.scheme is Https
    assert link.host == "example.com"
    assert link.port == none
    assert link.path == "/"
    assert link.segments == []
    assert link.query == map[string]string{}
    assert link.fragment == ""
}

fn test_it_parses_uppercase_domain() {
    link := Url.parse("https://EXAMPLE.COM")!

    assert link.scheme is Https
    assert link.host == "example.com"
    assert link.port == none
    assert link.path == "/"
    assert link.segments == []
    assert link.query == map[string]string{}
    assert link.fragment == ""
}

fn test_it_parses_url_with_scheme_with_leading_space() {
    link := Url.parse(" https://example.com")!

    assert link.scheme is Https
    assert link.host == "example.com"
    assert link.port == none
    assert link.path == "/"
    assert link.segments == []
    assert link.query == map[string]string{}
    assert link.fragment == ""
}

fn test_it_parses_url_with_domain_with_ending_space() {
    link := Url.parse("https://example.com ")!

    assert link.scheme is Https
    assert link.host == "example.com"
    assert link.port == none
    assert link.path == "/"
    assert link.segments == []
    assert link.query == map[string]string{}
    assert link.fragment == ""
}

fn test_it_parses_url_with_domain_containing_iso_characters() {
    link := Url.parse("https://münchen.de")!

    assert link.scheme is Https
    assert link.host == "münchen.de"
    assert link.port == none
    assert link.path == "/"
    assert link.segments == []
    assert link.query == map[string]string{}
    assert link.fragment == ""
}

fn test_it_returns_originally_parsed_url() {
    link := Url.parse("HTTPS://example.com")!

    assert link.original_url == "HTTPS://example.com"
    assert link.scheme is Https
    assert link.host == "example.com"
    assert link.port == none
    assert link.path == "/"
    assert link.segments == []
    assert link.query == map[string]string{}
    assert link.fragment == ""
}

fn test_it_returns_originally_parsed_query() {
    link := Url.parse("https://example.com?search=query")!

    assert link.raw_query == "search=query"
    assert link.scheme is Https
    assert link.host == "example.com"
    assert link.port == none
    assert link.path == "/"
    assert link.segments == []
    assert link.query == {"search": "query"}
    assert link.fragment == ""
}

fn test_it_handles_empty_query_values() {
    link := Url.parse("https://example.com?key=&other=value")!

    assert link.query["key"] or { "default" } == ""
    assert link.query["other"] or { "default" } == "value"
}

fn test_it_handles_query_without_value() {
    link := Url.parse("https://example.com?flag&key=value")!

    assert link.query["flag"] or { "missing" } == ""
}

fn test_it_handles_double_encoded_content() {
    link := Url.parse("https://example.com/path?q=%2520test")! // %20 encoded as %2520

    assert link.query["q"] or { "" } == "%20test"
}

fn test_it_reencode_query_using_uppercase_percent_encoding() {
    link := Url.parse("https://example.com/path?q=hello%2aworld")!

    assert link.query["q"] or { "" } == "hello*world"
    assert link.str() == "https://example.com/path?q=hello%2Aworld"
}

fn test_it_doesnt_parse_url_when_scheme_is_missing() {
    Url.parse("example.com") or {
        assert err.msg() == "The scheme is missing."
        assert err is MissingScheme
        return
    }

    assert false, "Expected invalid URL"
}

fn test_it_doesnt_parse_url_when_domain_is_missing() {
    Url.parse("https://") or {
        assert err.msg() == "The domain is missing."
        assert err is MissingDomain
        return
    }

    assert false, "Expected invalid URL"
}

fn test_it_doesnt_parse_url_when_traversing_to_parent_folder() {
    Url.parse("https://example.com/../") or {
        assert err.msg() == "The URL is accessing above the root directory."
        assert err is TraversingAboveRoot
        return
    }

    assert false, "Expected invalid URL"
}

fn test_it_doesnt_parse_url_when_path_is_badly_encoded() {
    Url.parse("https://example.com/path%") or {
        assert err.msg() == "The path is not well encoded."
        assert err is BadlyEncodedPath
        return
    }

    assert false, "Expected invalid URL"
}

fn test_it_doesnt_parse_url_when_fragment_is_badly_encoded() {
    Url.parse("https://example.com#section%") or {
        assert err.msg() == "The fragment is not well encoded."
        assert err is BadlyEncodedFragment
        return
    }

    assert false, "Expected invalid URL"
}

fn test_it_doesnt_parse_url_when_query_is_badly_encoded() {
    Url.parse("https://example.com?query=hello%") or {
        assert err.msg() == "The query is not well encoded."
        assert err is BadlyEncodedQuery
        return
    }

    assert false, "Expected invalid URL"
}

fn test_it_doesnt_parses_url_with_backslash_as_scheme_separator() {
    Url.parse("https:\\example.com") or {
        assert err is MissingScheme
        return
    }

    assert false, "Expected to reject backslash separator"
}
