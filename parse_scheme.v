module url

// parse_scheme converts a string scheme to a Scheme type
fn parse_scheme(scheme string) Scheme {
    return match scheme {
        'http' { Http{} }
        'https' { Https{} }
        'ftp' { Ftp{} }
        'ftps' { Ftps{} }
        'ssh' { Ssh{} }
        'git' { Git{} }
        'file' { File{} }
        else { Other{value: scheme} }
    }
}
