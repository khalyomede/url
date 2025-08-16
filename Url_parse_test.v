module test

import url { Url, Https, MissingDomain, MissingScheme, TraversingAboveRoot }

fn test_it_parses_url_with_domain_and_host() {
    url := Url.parse("https://example.com")!

    assert url.scheme == Https{}
    assert url.host == "example.com"
    assert url.port == none
    assert url.path == "/"
    assert url.query == map[string]string{}
    assert url.fragment == ""
}

fn test_it_parses_url_with_domain_host_and_port() {
    url := Url.parse("https://example.com:8080")!

    assert url.scheme == Https{}
    assert url.host == "example.com"
    assert url.port == 8080
    assert url.path == "/"
    assert url.query == map[string]string{}
    assert url.fragment == ""
}

fn test_it_parses_url_with_domain_host_and_path() {
    url := Url.parse("https://example.com/contact-us")!

    assert url.scheme == Https{}
    assert url.host == "example.com"
    assert url.port == none
    assert url.path == "/contact-us"
    assert url.query == map[string]string{}
    assert url.fragment == ""
}

fn test_it_parses_url_with_domain_host_and_multi_level_path() {
    url := Url.parse("https://example.com/api/v1/users")!

    assert url.scheme == Https{}
    assert url.host == "example.com"
    assert url.port == none
    assert url.path == "/api/v1/users"
    assert url.query == map[string]string{}
    assert url.fragment == ""
}

fn test_it_parses_url_with_host_domain_and_query() {
    url := Url.parse("https://example.com?search=query")!

    assert url.scheme == Https{}
    assert url.host == "example.com"
    assert url.port == none
    assert url.path == "/"
    assert url.query == map[string]string{"search": "query"}
    assert url.fragment == ""
}

fn test_it_parses_url_with_host_domain_and_fragment() {
    url := Url.parse("https://example.com#section1")!

    assert url.schemee == Https{}
    assert url.host == "example.com"
    assert url.port == none
    assert url.path == "/"
    assert url.query == map[string]string{}
    assert url.fragment == "section1"
}

fn test_it_parses_url_with_host_domain_and_relative_accessor_in_path() {
    url := Url.parse("https://example.com/settings/../contact")!

    assert url.scheme == Https{}
    assert url.host == "example.com"
    assert url.port == none
    assert url.path == "/contact"
    assert url.query == map[string]string{}
    assert url.fragment == ""
}

fn test_it_parses_url_with_host_domain_and_same_folder_accessor_in_path() {
    url := Url.parse("https://example.com/settings/./profile")!

    assert url.scheme == Https{}
    assert url.host == "example.com"
    assert url.port == none
    assert url.path == "/settings/profile"
    assert url.query == map[string]string{}
    assert url.fragment == ""
}

fn test_it_parses_url_with_host_domain_and_double_slashes_in_path() {
    url := Url.parse("https://example.com//settings//profile")!

    assert url.scheme == Https{}
    assert url.host == "example.com"
    assert url.port == none
    assert url.path == "/settings/profile"
    assert url.query == map[string]string{}
    assert url.fragment == ""
}

fn test_it_returns_originally_parsed_url() {
    url := Url.parse("HTTPS://example.com")!

    assert url.original == "HTTPS://example.com"
    assert url.scheme == Https{}
    assert url.host == "example.com"
    assert url.port == none
    assert url.path == "/"
    assert url.query == map[string]string{}
    assert url.fragment == ""
}

fn test_it_doesnt_parse_url_when_scheme_is_missing() {
    url := Url.parse("example.com") or {
        assert err.str() == "The scheme is missing."
        assert err is MissingScheme
    }

    assert false, "Expected invalid URL"
}

fn test_it_doesnt_parse_url_when_domain_is_missing() {
    url := Url.parse("https://") or {
        assert err.str() == "The domain is missing."
        assert err is MissingDomain
    }

    assert false, "Expected invalid URL"
}

fn test_it_doesnt_parse_url_when_traversing_to_parent_folder() {
    url := Url.parse("https://example.com/../") or {
        assert err.str() == "The URL is accessing above the root directory."
        assert err is TraversingAboveRoot
    }

    assert false, "Expected invalid URL"
}
