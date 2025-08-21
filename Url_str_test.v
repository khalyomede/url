module test

import khalyomede.expect { expect }
import khalyomede.faker { Faker }
import url { Url, Https }

fn test_it_returns_url_without_trailing_spaces() {
    mut fake := Faker{}
    domain := fake.top_level_domain()
    full_url := "https://${domain}.com/"

    link := Url.parse(" ${full_url} ")!

    expect(link.str()).to_be_equal_to(full_url)
}

fn test_it_returns_url_with_query_strings() {
    mut fake := Faker{}
    key := fake.word()
    value := fake.word()

    link := Url{
        scheme: Https{}
        host: "${fake.top_level_domain()}.com"
        query: {
            key: value
        }
    }

    expect(link.str()).to_be_equal_to("https://${link.host}?${key}=${value}")
}

fn test_it_returns_url_with_fragment() {
    mut fake := Faker{}
    fragment := fake.word()

    link := Url{
        scheme: Https{}
        host: "${fake.top_level_domain()}.com"
        fragment: fragment
    }

    expect(link.str()).to_be_equal_to("https://${link.host}#${fragment}")
}

fn test_it_returns_url_with_port() {
    mut fake := Faker{}
    port := fake.u16_between(min: 1, max: 65535)

    link := Url{
        scheme: Https{}
        host: "${fake.top_level_domain()}.com"
        port: port
    }

    expect(link.str()).to_be_equal_to("https://${link.host}:${port}")
}

fn test_it_returns_url_with_multi_level_paths() {
    mut fake := Faker{}
    path1 := fake.word()
    path2 := fake.word()

    link := Url{
        scheme: Https{}
        host: "${fake.top_level_domain()}.com"
        path: "${path1}/${path2}"
    }

    expect(link.str()).to_be_equal_to("https://${link.host}/${path1}/${path2}")
}
