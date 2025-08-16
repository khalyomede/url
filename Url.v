module url

pub struct Url {
    pub:
        scheme Scheme
        host string
        port ?u16
        path string
        query map[string]string
        fragment string
        original_url string
        raw_query string
}
