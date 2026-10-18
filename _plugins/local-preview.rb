# The public site's CSP stays unchanged. Only the local config opts into the
# exact loopback origins used by Jekyll's development LiveReload server.
Jekyll::Hooks.register [:pages, :documents], :post_render do |document|
  next unless Jekyll.env == "development" && document.site.config["local_preview_livereload"]
  next unless document.output_ext == ".html"

  document.output = document.output.sub(
    "script-src 'self'",
    "script-src 'self' http://localhost:35729 http://127.0.0.1:35729"
  ).sub(
    "connect-src 'self'",
    "connect-src 'self' ws://localhost:35729 ws://127.0.0.1:35729"
  )
end
