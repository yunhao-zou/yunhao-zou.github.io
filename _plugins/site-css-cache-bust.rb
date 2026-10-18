# The core theme's CSS digest covers gem-owned Sass but omits this site's overrides.
require 'digest'

module SiteCssCacheBust
  def bust_css_cache(file_name)
    site_source = @context.registers[:site].source
    local_files = Dir[File.join(site_source, '_sass', '**', '*.scss')].sort
    local_files << File.join(site_source, 'assets', 'css', 'main.scss')
    local_digest = Digest::SHA256.new
    local_files.each { |path| local_digest << File.binread(path) if File.file?(path) }

    theme_version = Jekyll::CacheBust::CacheDigester.new(file_name: file_name, directory: 'assets/_sass').digest!
    "#{theme_version}&local=#{local_digest.hexdigest[0, 16]}"
  end
end

Liquid::Template.register_filter(SiteCssCacheBust)
