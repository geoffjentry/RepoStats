## FIXME: Needs to handle pagination
release_downloads = function(owner, repo, release_id) {
  release = full_results("/repos/:owner/:repo/releases/:release_id", owner=owner, repo=repo, release_id=release_id)
  downloads = t(as.data.frame(lapply(release$assets, function(q) c(q$name, release$published_at, q$download_count))))
  rownames(downloads) = NULL
  colnames(downloads) = c("file", "published", "count")
  downloads
}

repo_downloads = function(owner, repo) {
  releases = full_results("/repos/:owner/:repo/releases", owner=owner, repo=repo)
  release_ids = sapply(releases, function(x) x$id)
  do.call(rbind, lapply(release_ids, function(x) release_downloads(owner, repo, x)))
}

forks = function(owner, repo) {
  full_results("/repos/:owner/:repo/forks", owner=owner, repo=repo)
}

stars = function(owner, repo) {
  full_results("/repos/:owner/:repo/stargazers", owner=owner, repo=repo)
}

full_results = function(url, ...) {
  cur_page = 0
  continue = TRUE
  results = list()
  
  while (continue) {
    cur_page = cur_page + 1
    cur_results = gh(url, ..., page=cur_page)
    if (is.list(cur_results)) {
      results = c(results, cur_results)
    } else {
      continue = FALSE
    }
  }
  
  results
}