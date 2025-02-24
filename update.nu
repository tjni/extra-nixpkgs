use std/iter

let system_to_os = {
  "x86_64-linux": "linux-x64",
  "aarch64-linux": "linux-arm64",
  "x86_64-darwin": "darwin",
  "aarch64-darwin": "darwin-arm64"
}

let systems = $system_to_os | columns

let to_source = {|system|
  let os = $system_to_os | get $system
  let url = $'https://code.visualstudio.com/sha/download?build=insider&os=($os)'
  let out = nix store prefetch-file --name insiders --json --hash-type sha256 $url | from json
  { url: $url, hash: $out.hash }
}

let sources = $systems | par-each --keep-order $to_source

let system_sources = $systems | iter zip-into-record $sources | into record

$system_sources | to json | save -f "sources.json"
