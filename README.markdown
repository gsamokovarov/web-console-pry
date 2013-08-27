Deprecated
==========

> [Web Console] doesn't try to be a terminal emulator.

When we started out with [Web Console], we didn't wanted to use a full-blown
terminal emulator on the web, but rather simulate the experience. However, some
of the ideas we had about the project turn out to be hard or impossible with
that approach.

As of [v0.3.0][Web Console], [Web Console] comes with a full featured VT100
compatible terminal emulator. This makes any adapter obsolete, as we can easily
run any terminal process. Running your pager or favorite terminal editor in
_Pry_ is no longer a hassle.

We encourage you to just use the latest [Web Console]. Version [v0.2.1] would
be the last one for [web-console-pry][v0.2.1].

  [Web Console]: https://github.com/gsamokovarov/web-console
  [v0.2.1]: https://github.com/gsamokovarov/web-console-pry/tree/v0.2.1
