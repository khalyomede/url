module test

import url { Url }

fn test_it_returns_url_without_trailing_spaces() {
    link := Url.parse(" https://example.com/ ")!

    assert link.str() == "https://example.com"
}
