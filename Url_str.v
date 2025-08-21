module url

import net.urllib { query_escape }

pub fn (link Url) str() string {
    mut result := "${link.scheme.str()}://${link.host}".to_lower()

    if link.port != none {
        result += ":${link.port}"
    }

    if link.path != "" {
        result += "/" + link.path
            .split("/")
            .filter(it.trim_space().len > 0)
            .map(query_escape(it))
            .join("/")
    }

    if link.query.len > 0 {
        mut queries := []string{}

        for key, value in link.query {
            queries << "${query_escape(key)}=${query_escape(value)}"
        }

        result += "?" + queries.join("&")
    }

    if link.fragment != "" {
        result += "#${query_escape(link.fragment)}"
    }

    return result
}
