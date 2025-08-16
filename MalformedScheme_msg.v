module url

pub fn (error MalformedScheme) msg() string {
    return "The scheme is malformed."
}
