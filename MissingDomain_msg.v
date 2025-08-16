module url

pub fn (error MissingDomain) msg() string {
    return "The domain is missing."
}
