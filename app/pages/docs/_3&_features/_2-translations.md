---
title: Translations
published: true
---

<{ :toc }>

Because of the way Antlers syntax is designed you can translate text without any `t()` functions, just use existing strings:
```ruby
<html>{"Hello"}</html>
```

Every string in `{}` goes through Antlers, so every one can be translated.  
Text written directly into HTML like `<p>Hello</p>` isn't translated.

## Strings

Translations are mapped via a YAML file, where the top level keys represent a [language code](https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes) or region like `en-US:`, followed by key-value mappings of the string to translate from and to.

In `config/translations.yaml` put:
```yaml
es:
  'Hello': 'Hola'
```

A translation replaces the whole string, so `'Hello'` translates `{"Hello"}` but not `{"Hello world"}`. A string without a translation renders as it's written.

## Symbols

You can go one layer of abstraction deeper, instead of replacing the literal text, you can translate a symbol that represents that text. Symbols are useful for text that's long, changes often or appears in many places.

Prefix the symbol with a colon and separate words with underscores:
```ruby
<html>{:app_name}</html>
```

Then in `config/translations.yaml` put its value under `symbols`, using a YAML key without the colon or quotes:
```yaml
symbols:
  app_name: 'Raindeer'
```

The symbol's value is then translated like any other string:
```yaml
symbols:
  app_name: 'Raindeer'
es:
  'Raindeer': 'Renos'
```

A symbol without a value in `symbols` renders its name, like `app_name`.

## Locale

Set the language your templates are written in with the `source_locale` option in `config/config.yaml`. It defaults to `en`:
```yaml
source_locale: 'de'
```

Each request is rendered in the most preferred language from its `Accept-Language` header that is either the `source_locale` or has translations. A regional language like `es-MX` falls back to `es`. When no language matches, the request is rendered in the `source_locale`, with strings as they're written.

With `source_locale: 'en'` and `es` translations:

| `Accept-Language` | Rendered in |
|---|---|
| `es-MX,es;q=0.9` | `es` |
| `en,es;q=0.5` | `en` |
| `fr` | `en` |
| None | `en` |

Responses say which language they're in with a `Content-Language` header, and include `Vary: Accept-Language` so caches don't serve one language to everyone.

> [!NOTE]
> [Static](/docs/static) builds have no `Accept-Language` header, so pages are built in the `source_locale`.

## HTML

Translations are HTML escaped like any other `{}` variable. Use the `<{"Hello"}>` Deerheads syntax to render a translation containing HTML.

Only strings and `:symbols` are translated, never the values of methods or instance variables like `{@user.bio}`. To translate variables use the API.

## API

Translate strings outside of templates with `Antlers::Translations.translate`, which uses the same language as the request. In a request rendered in `es`:
```ruby
Antlers::Translations.translate('Hello') # => "Hola"
Antlers::Translations.translate(:app_name) # => "Renos"
```
