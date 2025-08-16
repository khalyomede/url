module url

import net.urllib { query_unescape }

pub fn Url.parse(raw_url string) !Url {
    // Check if scheme exists
    scheme_separator := '://'
    scheme_index := raw_url.index(scheme_separator) or {
        return MissingScheme{}
    }

    if scheme_index == 0 {
        return MissingScheme{}
    }

    // Extract and parse scheme
    raw_scheme := raw_url[..scheme_index].to_lower()
    scheme := parse_scheme(raw_scheme)

    // Start parsing after scheme://
    remaining := raw_url[scheme_index + scheme_separator.len..]

    if remaining.len == 0 {
        return MissingDomain{}
    }

    // Find the end of host:port section
    mut host_end := remaining.len

    // Check for path
    if path_index := remaining.index('/') {
        host_end = path_index
    }

    // Check for query
    if query_index := remaining.index('?') {
        if query_index < host_end {
            host_end = query_index
        }
    }

    // Check for fragment
    if fragment_index := remaining.index('#') {
        if fragment_index < host_end {
            host_end = fragment_index
        }
    }

    host_part := remaining[..host_end].trim_space()

    if host_part.len == 0 {
        return MissingDomain{}
    }

    // Parse host and port
    mut host := ''
    mut port := ?u16(none)

    if colon_index := host_part.last_index(':') {
        host = host_part[..colon_index].to_lower()
        port_str := host_part[colon_index + 1..]

        if port_str.len > 0 {
            port = u16(port_str.int())
        }
    } else {
        host = host_part.to_lower()
    }

    // Parse the rest of the URL
    rest := remaining[host_end..]

    // Parse path, query and fragment
    mut path := '/'
    mut query := map[string]string{}
    mut raw_query := ''
    mut fragment := ''

    if rest.len > 0 {
        mut path_end := rest.len
        mut query_start := -1
        mut fragment_start := -1

        // Find query start
        if query_index := rest.index('?') {
            query_start = query_index
            path_end = query_index
        }

        // Find fragment start
        if fragment_index := rest.index('#') {
            fragment_start = fragment_index

            if fragment_start < path_end {
                path_end = fragment_start
            }
        }

        // Extract path
        if path_end > 0 {
            raw_path := rest[..path_end]

            decoded_path := query_unescape(raw_path) or {
                return BadlyEncodedPath{}
            }

            path = normalize_path(decoded_path)!
        }

        // Extract query
        if query_start >= 0 {
            mut query_end := rest.len

            if fragment_start > query_start {
                query_end = fragment_start
            }

            raw_query = rest[query_start + 1..query_end]

            query = parse_query(raw_query) or {
                return BadlyEncodedQuery{}
            }
        }

        // Extract fragment
        if fragment_start >= 0 {
            fragment = query_unescape(rest[fragment_start + 1..]) or {
                return BadlyEncodedFragment{}
            }
        }
    }

    return Url{
        scheme: scheme
        host: host
        port: port
        path: path
        query: query
        raw_query: raw_query
        fragment: fragment
        original_url: raw_url
    }
}
