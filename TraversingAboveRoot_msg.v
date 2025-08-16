module url

pub fn (error TraversingAboveRoot) msg() string {
    return "The URL is accessing above the root directory."
}
