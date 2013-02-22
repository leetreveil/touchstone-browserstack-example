set -e

JSON='{
  "http server": {
    "cmd": "python",
    "args": ["-m", "SimpleHTTPServer"],
    "color": "red"
  },
  "test result collector": {
    "cmd": "node",
    "args": ["node_modules/touchstone/trecv.js"],
    "color": "blue",
    "use_ret_code": true,
    "wait": 5000
  },
  "tunnel": {
    "cmd": "java",
    "args": ["-jar", "node_modules/browserstack-cli/bin/BrowserStackTunnel.jar", "REDACTED[INSERT YOUR BROWSERSTACK AUTOMATED TESTING KEY HERE]", "localhost,8000,0,localhost,1942,0"],
    "deps": ["http server", "test result collector"],
    "color": "green"
  },
  "test runner": {
    "cmd": "node_modules/browserstack-cli/bin/cli.js",
    "args": ["launch", "--attach", "ie:10.0", "http://localhost:8000/test.html"],
    "deps": ["tunnel"],
    "color": "yellow"
  }
}'

BROWSERS=(ie:8.0 ie:9.0 ie:10.0)

for i in ${BROWSERS[@]}; do
    echo ${JSON/ie:10.0/$i} | dictator
done