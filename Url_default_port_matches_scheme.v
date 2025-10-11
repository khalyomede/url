module url

fn (link Url) default_port_matches_scheme() bool {
    scheme_default_port := match link.scheme {
        Http { 80 }
        Https { 443 }
        Ftp { 21 }
        Ftps { 990 }
        Ssh { 22 }
        else { none }
    }

    return link.port == scheme_default_port
}
