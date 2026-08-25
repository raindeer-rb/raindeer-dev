---
title: Translations [UNRELEASED]
published: true
menu: Translations
---

<{ :toc }>

> [!note]
> Under development, API subject to change.

Because of the way Antlers syntax is designed you can translate text without any `t()` functions, just use existing strings:
```ruby
<html>{"Hello"}</html>
```

All strings go through Antlers so all strings can be translated.

## Mapping

Translations are mapped via a YAML file, where the top level keys represent the `default` or [language code](https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes), followed by key-value mappings of the string to translate from and to.

In `config/translations.yml` put:
```yaml
es:
  'Hello': 'Hola'
```

## Variables

You can go one layer of extraction deeper, instead of replacing the literal text, you can translate a "variable" representation of that text.

Prefix the variable with a colon a separate words with underscores:
```ruby
<html>{:app_name}</html>
```

Then in `config/translations.yml` use a YAML key without quotes:
```yaml
default:
  app_name: 'Raindeer'
```
