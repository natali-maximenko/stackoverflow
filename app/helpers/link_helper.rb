module LinkHelper
  def gist?(link)
    link.url.include?('https://gist.github.com/')
  end
end