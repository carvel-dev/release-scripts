def addProtocol(url):
  if url.startswith("https"):
    return url
  elif url.startswith("http://"):
    return url.replace("http", "https")
  end
  return "https://" + url
end
