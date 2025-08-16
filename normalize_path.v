module url

fn normalize_path(raw_path string) !string {
    if raw_path.len == 0 {
        return '/'
    }

    mut path := raw_path

    // Ensure path starts with /
    if !path.starts_with('/') {
        path = '/' + path
    }

    // Make folder accessors absolute
    segments := path.split('/')
    mut resolved := []string{}

    for segment in segments {
        if segment == '' || segment == '.' {
            continue
        }

        if segment == '..' {
            if resolved.len == 0 {
                return TraversingAboveRoot{}
            }
            resolved.delete_last()
        } else {
            resolved << segment
        }
    }

    mut result := '/' + resolved.join('/')

    // Remove trailing slash unless it's root
    if result.len > 1 && result.ends_with('/') {
        result = result[..result.len - 1]
    }

    return result
}
