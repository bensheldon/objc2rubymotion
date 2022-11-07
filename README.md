objc2rubymotion
===============

**Objective-C to Rubymotion Converter**: Use it at http://objc2rubymotion.herokuapp.com/

Based on the [Sublime-ObjcToRubyMotion](https://github.com/thinkclay/Sublime-ObjcToRubyMotion) plugin. Inspiration to the [Atom-Objc2Rubymotion](https://github.com/ahmetabdi/atom-objc-2-rubymotion) plugin.

Implementation
--------------

Coffeescript mostly; statically built with Jekyll. Currently performs the following conversions:

 - removes semicolons at end of lines
 - replaces NSString with ruby strings
 - converts square bracketed `[method message]` calls to `method.message` calls, and reformats their arguments
 - removes `autorelease` declarations
 - removes removes type declarations

View the [list of tests](assets/javascripts/spec/converter_spec.coffee) for a full list of conversions that are performed.

Development
-----------

Install it locally.

```bash
$ bundle install
```

Run it:

```bash
$ bundle exec jekyll serve
```

Visit it: http://localhost:4000/objc2rubymotion

