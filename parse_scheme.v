module url

// parse_scheme converts a string scheme to a Scheme type
fn parse_scheme(scheme string) Scheme {
    trimmed_scheme := scheme.trim_space()

    return match trimmed_scheme {
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
