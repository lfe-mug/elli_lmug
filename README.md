
# lmug-elli

[![img](https://travis-ci.org/lfe-mug/lmug-elli.svg)](https://travis-ci.org/lfe-mug/lmug-elli)
[![img](https://img.shields.io/github/tag/lfe-mug/lmug-elli.svg)](https://github.com/lfe-mug/lmug-elli/releases/latest)
[![img](https://img.shields.io/badge/erlang-%E2%89%A5R16B03-red.svg)](http://www.erlang.org/downloads)
[![img](https://img.shields.io/badge/docs-75%25-green.svg)](http://lfe-mug.github.io/lmug-elli)
[![img](https://img.shields.io/badge/license-Apache-blue.svg)](LICENSE)

[![img](resources/images/lmug-elli.png)](resources/images/lmug-elli-large.png)

*An lmug [adaptor](https://github.com/lfe-mug/lmug#adaptors-) for the [Elli](https://github.com/knutin/elli) web server.*

## Contents

-   [Introduction](#introduction-)
-   [Installation](#installation-)
-   [Usage](#usage-)
-   [Documentation](#documentation-)
-   [License](#license-)

## Introduction [↟](#contents)

TBD

## Installation [↟](#contents)

Just add it to your `rebar.config` `deps`:

```erlang
{deps, [
  {lmug_elli,
   {git, "git://github.com/lfe-mug/lmug-elli.git",
    {tag, "0.3.1"}}}
]}.
```

## Usage [↟](#contents)

```lfe
> (include-lib "clj/include/compose.lfe")
loaded-compose
> (set app (-> (lmug:response)
               (lmug-mw-identity:wrap)
               (lmug-mw-content-type:wrap)
               (lmug-mw-identity:wrap)))
#Fun<lmug-mw-content-type.0.87096894>
> (set opts '[#(port 3002)])
(#(port 3002))
> (lmug-elli:run app opts)
```

```fish
http :3002/file.json
```

```http
HTTP/1.1 200 OK
Connection: Keep-Alive
Content-Length: 0
Content-Type: application/json
```

## Documentation [↟](#contents)

-   The [lmug spec](https://github.com/lfe-mug/lmug/blob/master/docs/SPEC.md) — based on the Clojure [Ring spec](https://github.com/ring-clojure/ring/blob/master/SPEC).
-   The [lmug\_elli API reference](http://lfe-mug.github.io/lmug-elli).

## License [↟](#contents)

    Copyright © 2016 LFE Dragon Team

    Distributed under the Apache License, Version 2.0.
