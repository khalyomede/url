module url

pub fn (error BadlyEncodedQuery) msg() string {
    return "The query is not well encoded."
}
