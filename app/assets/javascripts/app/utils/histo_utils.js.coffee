Histo.Utils =

  removeURIParameter: (url, param) ->
    url = url.toString()
    urlparts = url.split('?')
    return url if urlparts.length < 2

    prefix = encodeURIComponent(param) + '='
    pars = urlparts[1].split(/[&;]/g)

    while (i = pars.length and i--)
      if pars[i].lastIndexOf(prefix, 0) != -1
        pars.splice(i, 1)

    if pars.length
      url = urlparts[0] + '?' + pars.join('&')
    else
      url = urlparts[0]

    url
