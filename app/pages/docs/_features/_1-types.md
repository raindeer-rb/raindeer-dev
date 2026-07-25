---
title: Types
---

<{ :toc }>

Raindeer supports types out of the box via <a href="https://github.com/low-rb/low_type" title="GitHub">LowType</a>. LowType introduces the concept of "type expressions" in method arguments. When an argument's default value is a type instead of a value then it's treated as a type expression, which will check the type:

```ruby
class MyNode < LowNode
  def say_hello(greeting: String)
    # Raises exception at runtime if greeting is not a String.
  end
end
```

## Default values

Place `|` after the type definition to provide a default value when the argument is `nil`:
```ruby
def say_hello(greeting = String | 'Hello')
  puts greeting
end
```

Or with keyword arguments:
```ruby
def say_hello(greeting: String | 'Hello')
  puts greeting
end
```

## Enumerables

Wrap your type in an `Array[T]` or `Hash[T]` enumerable type. An `Array` of `String`s looks like:
```ruby
def say_hello(greetings: Array[String])
  greetings # => ['Hello', 'Howdy', 'Hey']
end
```

Represent a `Hash` with `key => value` syntax:
```ruby
def say_hello(greetings: Hash[String => Integer])
  greetings # => {'Hello' => 123, 'Howdy' => 456, 'Hey' => 789})
end
```

## Return values

After your method's parameters add `-> { T }` to define a return value:
```ruby
def say_hello() -> { String }
  'Hello' # Raises exception if the returned value is not a String.
end
```

Return values can also be defined as `nil`able:
```ruby
def say_hello(greetings: Array[String]) -> { String | nil }
  return nil if greetings.first == 'Goodbye'
  greetings.first
end
```

If you need a multi-line return type/value then I'll even let you put the `-> { T }` on multiple lines, okay? I won't judge. You are a unique flower 🌸 with your own style, your own needs. You have purpose in this world and though you may never find it, your loved ones will cherish knowing you and wish you were never gone:
```ruby
def say_farewell_with_a_long_method_name(farewell: String)
  -> {
    ::Long::Name::Space::CustomClassOne | ::Long::Name::Space::CustomClassTwo | ::Long::Name::Space::CustomClassThree
  }

  # Code that returns an instance of one of the above types.
end
```

## Instance variables

To define typed `@instance` variables use the `type_[reader, writer, accessor]` methods.  
These replicate `attr_[reader, writer, accessor]` methods but also allow you to define and check types.

### Type Reader

```ruby
type_reader name: String # Creates a public method called `name` that gets the value of @name
name # Get the value with type checking

type_reader name: String | 'Cher' # Gets the value of @name with a default value if it's `nil`
name # Get the value with type checking and return 'Cher' if the value is `nil`
```

### Type Writer

```ruby
type_writer name: String # Creates a public method called `name=(arg)` that sets the value of @name
name = 'Tim' # Set the value with type checking
```

### Type Accessor

```ruby
type_accessor name: String # Creates public methods to get or set the value of @name
name # Get the value with type checking
name = 'Tim' # Set the value with type checking

type_accessor name: String | 'Cher' # Get/set the value of @name with a default value if it's `nil`
name # Get the value with type checking and return 'Cher' if the value is `nil`
name = 'Tim' # Set the value with type checking
```

### Multiple Arguments

You can define multiple typed methods at once just like you would with `attr_[reader, writer, accessor]`:
```ruby
type_accessor name: String | nil, occupation: 'Doctor', age: Integer | 33
name # => nil
occupation # => Doctor (not type checked)
age = 'old' # => Raises ArgumentTypeError
age # => 33
```

ℹ️ To use the `Array[]`/`Hash[]` enumerable syntax with type accessors you must add `using LowType::Syntax`:
```ruby
include LowType
using LowType::Syntax
```

## Local variables

### `type()`

*alias: `low_type()`*

To define typed `local` variables at runtime use the `type()` method:
```ruby
my_var = type MyType | fetch_my_object(id: 123)
```

`my_var` is now type checked to be of type `MyType` when assigned to.

Don't forget that these are just Ruby expressions and you can do more conditional logic as long as the last expression evaluates to a value:
```ruby
my_var = type String | (say_goodbye || 'Hello Again')
```

## Syntax

### `[T]` Enumerables

`Array[T]` and `Hash[T]` class methods represent enumerables in the context of type expressions. If you need to create a new `Array`/`Hash` then use `Array.new()`/`Hash.new()` or Array and Hash literals `[]` and `{}`. This is the same syntax that [RBS](https://github.com/ruby/rbs) uses and we need to get use to these class methods returning type expressions if we're ever going to have inline types in Ruby. [RuboCop](https://www.rubydoc.info/gems/rubocop/RuboCop/Cop/Style/HashConversion) also suggests `{}` over `Hash[]` syntax for creating hashes.

ℹ️ To use the `Array[]`/`Hash[]` enumerable syntax with `type()` you must add `using LowType::Syntax`:
```ruby
include LowType
using LowType::Syntax
```

### `|` Union Types / Default Value

The pipe symbol (`|`) is used in the context of type expressions to define multiple types as well as provide the default value:
- To allow multiple types separate them between pipes: `my_var = TypeOne | TypeTwo`
- The last *value*/`nil` defined becomes the default value: `my_var = TypeOne | TypeTwo | nil`

ℹ️ If no default value is defined then the argument will be required.

### Nilable values

- Represent a nilable value with `T | nil`
- Represent an empty hash with `Hash | {}`

### `-> { T }` Return Type

The `-> { T }` syntax is a lambda without an assignment to a local variable. This is valid Ruby that can be placed immediately after a method definition and on the same line as the method definition, to visually look like the output of that method. It's inert and doesn't run when the method is called, similar to how default values are never called if the argument is managed by LowType. Pretty cool stuff yeah? Your type expressions won't keep re-evaluating in the wild 🐴, only on class load.

ℹ️ A method that takes no arguments must include empty parameters `()` for the `-> { T }` syntax to be valid; `def method() -> { T }`.

### `value(T)` Value Expression

*alias: `low_value()`*

To treat a type as if it were a value, pass it through `value()` first:
```ruby
def my_method(my_arg: String | MyType | value(MyType)) # => MyType is the default value
```

## Types

### Basic types

- `String`
- `Integer`
- `Float`
- `Array`
- `Hash`
- `nil` represents an optional value

### Complex types

- `Boolean` - Accepts `true`/`false`) [UNRELEASED]
- `Enum` - Usage: `Enum[1, 2, 3]` [[CONCEPT STAGE](https://github.com/low-rb/low_type/issues/6)]
- `Tuple` (subclass of `Array`)
- `Status` (subclass of `Integer`)
- `Headers` (subclass of `Hash`)
- `HTML` (subclass of `String`) - TODO: Check that string is HTML
- `JSON` (subclass of `String`) - TODO: Check that string is JSON
- `XML` (subclass of `String`) - TODO: Check that string is XML

### Custom types

Any class/type that's available to Ruby is available to LowType. LowType evaluates parameter types in both the binding of LowType and the binding of the class that did the `include`.
