module url

pub fn (scheme Scheme) str() string {
    return match scheme {
        Http { 'http' }
        Https { 'https' }
        Ftp { 'ftp' }
        Ftps { 'ftps' }
        Ssh { 'ssh' }
        Git { 'git' }
        File { 'file' }
        Other { scheme.value }
    }
}
