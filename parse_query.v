module url

import net.urllib

// Todo: make the method return an error if the query string is malformed.
fn parse_query(query_string string) !map[string]string {
    values := urllib.parse_query(query_string)!

    // Keeping only the last value for each key
    mut query := map[string]string{}

    for key, value_array in values.to_map() {
        if value_array.len > 0 {
            for item in value_array {
                query[key] = item
            }
        }
    }

    return query
}
