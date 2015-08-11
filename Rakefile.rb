# Ping Google
desc 'Notify Google of the new sitemap'
task :sitemapgoogle do
    begin
        require 'net/http'
        require 'uri'
        puts '* Pinging Google about our sitemap'
        Net::HTTP.get('www.google.com', '/webmasters/tools/ping?sitemap=' + URI.escape('http://www.artsoftheinsane.com/sitemap.xml'))
    rescue LoadError
        puts '! Could not ping Google about our sitemap, because Net::HTTP or URI could not be found.'
    end
end

# Ping Bing
desc 'Notify Bing of the new sitemap'
task :sitemapbing do
    begin
        require 'net/http'
        require 'uri'
        puts '* Pinging Bing about our sitemap'
        Net::HTTP.get('www.bing.com', '/webmaster/ping.aspx?siteMap=' + URI.escape('http://www.artsoftheinsane.com/sitemap.xml'))
    rescue LoadError
        puts '! Could not ping Bing about our sitemap, because Net::HTTP or URI could not be found.'
    end
end

# rake notify
desc 'Notify various services about new content'
task :notify => [:sitemapgoogle, :sitemapbing] do
end

# rake rsync
desc 'rsync the contents of ./_site to the server'
task :rsync do
    puts '* rsyncing the contents of ./_site to the server'
    system 'rsync -prvz --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r _site/ ekoagency.com@s98164.gridserver.com:domains/mademistakes.com/html/'
end
