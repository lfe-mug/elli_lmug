
# lmug-elli

[![img](resources/images/lmug-elli.png)](resources/images/lmug-elli-large.png)

*An lmug [adaptor](https://github.com/lfe-mug/lmug#adaptors-) for the [Elli](https://github.com/knutin/elli) web server.*

## Contents

-   [Introduction](#introduction-)
-   [Installation](#installation-)
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
    {tag, "0.2.2"}}}
]}.
```

## Documentation [↟](#contents)

-   The [lmug spec](https://github.com/lfe-mug/lmug/blob/master/docs/SPEC.md) — based on the Clojure [Ring spec](https://github.com/ring-clojure/ring/blob/master/SPEC).
-   The [lmug-elli API reference](http://lfe-mug.github.io/lmug-elli).

## License [↟](#contents)

    Copyright © 2016 LFE Dragon Team
    
    Distributed under the Apache License, Version 2.0.
