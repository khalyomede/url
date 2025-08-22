module url

import net.urllib { query_escape, path_escape }

pub fn (link Url) str() string {
    mut result := "${link.scheme.str()}://${link.host}".to_lower()

    if link.port != none {
        result += ":${link.port}"
    }

    if link.segments.len > 0 {
        result += "/" + link.segments
            .filter(it.trim_space().len > 0)
            .map(path_escape(it))
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
        result += "#${path_escape(link.fragment)}"
    }

    return result
}
