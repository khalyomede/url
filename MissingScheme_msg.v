module url

pub fn (error MissingScheme) msg() string {
    return "The scheme is missing."
}
