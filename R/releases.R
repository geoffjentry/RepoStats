release_downloads = function(owner, repo, release_id) {
  release = gh("/repos/:owner/:repo/releases/:release_id", owner=owner, repo=repo, release_id=release_id)
  downloads = t(as.data.frame(lapply(release$assets, function(q) c(q$name, release$published_at, q$download_count))))
  rownames(downloads) = NULL
  colnames(downloads) = c("file", "published", "count")
  downloads
}

repo_downloads = function(owner, repo) {
  releases = gh("/repos/:owner/:repo/releases", owner=owner, repo=repo)
  release_ids = sapply(releases, function(x) x$id)
  do.call(rbind, lapply(release_ids, function(x) release_downloads(owner, repo, x)))
}