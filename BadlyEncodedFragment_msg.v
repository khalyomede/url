module url

pub fn (error BadlyEncodedFragment) msg() string {
    return "The fragment is not well encoded."
}
