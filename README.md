# PrezIRB
### irb browser based presentations
<https://github.com/makevoid/prezirb>

### running the demo presentation:

download/clone the repo

    bundle
    ruby prezirb.rb

open prezirb.html in your browser


### usage

- cmd+enter   = run command
- cmd+up/down = history

cmd is meta key


### presentation

your presentation stays in presentation.coffee file, it's an array of hashes containing slides (code snippets) you can easily paste in PreziIRB with a click

this project has been forked brirb, you can find the source at <https://github.com/rkh/brirb>


### development

to improve PreziIRB you need to install the watcher gem:

    gem i watcher

then run:

    watchr prezirb.watchr

then if you edit a coffeescript, haml or sass file and save it it will get compiled