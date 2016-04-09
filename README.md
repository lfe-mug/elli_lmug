
# lmug-elli

[![img](https://travis-ci.org/lfe-mug/lmug-elli.svg)](https://travis-ci.org/lfe-mug/lmug-elli)
[![img](https://img.shields.io/github/tag/lfe-mug/lmug-elli.svg)](https://github.com/lfe-mug/lmug-elli/releases/latest)
[![img](https://img.shields.io/badge/erlang-%E2%89%A5R16B03-red.svg)](http://www.erlang.org/downloads)
[![img](https://img.shields.io/badge/docs-67%25-green.svg)](http://lfe-mug.github.io/lmug-elli)
[![img](https://img.shields.io/badge/license-Apache-blue.svg)](LICENSE)

[![img](resources/images/lmug-elli.png)](resources/images/lmug-elli-large.png)

*An lmug [adaptor](https://github.com/lfe-mug/lmug#adaptors-) for the [Elli](https://github.com/knutin/elli) web server.*

## Contents

-   [Introduction](#introduction-)
-   [Installation](#installation-)
-   [Usage](#usage-)
    -   [Simple Example](#simple-example-)
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
    {tag, "0.2.3"}}}
]}.
```

## Usage [↟](#contents)

### STARTED Simple Example [↟](#contents)

-   Middleware: `lmug-mw-example`

    To make for a simple example, our `lmug-mw-example` is the identity middleware.
    
    ```lfe
    (defmodule lmug-mw-example
      (export (wrap 2)))
    
    (defun wrap (handler opts)
      (lambda (req)
        (funcall handler opts)))
    ```

-   Supervisor: `example-sup`

    The key point here is to set up your `lmug-elli` middleware.  As with *normal*
    Elli middlewares, you pass a module name, `lmug-elli`, and a list of `args`.  In
    this case, `lmug-elli` expects your `args` list to be of the form:
    
    ```lfe
    [#(lmug-mw-mod-name (= [#(opt-name opt-value) ...] opts)) ...]
    ```
    
    For our example, will use a single lmug middleware, `lmug-mw-example` from
    above, and pass it the empty list as `opts`:
    
        #(lmug-elli [#(lmug-mw-example [])])
    
    With your middleware configured, start and supervise `elli` as normal:
    
    ```lfe
    (defmodule example-sup
      (behaviour supervisor)
      ;; API
      (export (start_link 0))
      ;; Supervisor callbacks
      (export (init 1)))
    
    (defun start_link ()
      (supervisor:start_link `#(local ,(MODULE)) (MODULE) []))
    
    (defun init
      ([()]
       (let* ((callback_args `[#(mods [#(lmug-elli [#(lmug-mw-example [])])])])
              (config        `[#(callback      elli_middleware)
                               #(callback_args ,config)
                               #(port          8080)]))
         #(ok #(#m(intensity 5 period 10)
                [#m(id example start #(elli start_link []))])))))
    ```

## Documentation [↟](#contents)

-   The [lmug spec](https://github.com/lfe-mug/lmug/blob/master/docs/SPEC.md) — based on the Clojure [Ring spec](https://github.com/ring-clojure/ring/blob/master/SPEC).
-   The [lmug-elli API reference](http://lfe-mug.github.io/lmug-elli).

## License [↟](#contents)

    Copyright © 2016 LFE Dragon Team
    
    Distributed under the Apache License, Version 2.0.
