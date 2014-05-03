#!/usr/bin/env bats

@test "search is working" {
  curl http://localhost:8080/solr/dummy/select\?q=id:1 -I 2>/dev/null | head -n1 | grep 200
}
