module url

pub fn (error BadlyEncodedPath) msg() string {
    return "The path is not well encoded."
}
