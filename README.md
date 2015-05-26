# Global Settings Model

Example ActiveRecord model for storing global configuration settings.

## Usage

Super simple key-value pair storage. Right now, it supports string, integer, float, and boolean types, but adding new types is as simple as creating a migration and altering the `GLOBAL_SETTING_DATATYPES` hash (in /config/initializers).

Use example:
    GlobalSetting.set('admin-email', 'admin@example.com')
    GlobalSetting.get('admin-email')
    # => 'admin@example.com'
    GlobalSetting.unset('admin-email')

You can also directly alter GlobalSetting instances:
    setting = GlobalSetting.last
    setting.value = 42
    setting.save

The type handling happens behind the scenes so you don't have to think about it! Just alter that `GLOBAL_SETTING_DATATYPES` if you want to change how things are stored.

Check the comments or generate rdoc to see the full documenation.

## Approach

First, I thought out the public API. Taking a cue from localStorage in HTML5, I decided a simple key-value pair would be ideal, and the type handling could happen under the hood. This lead to `#set`, `#get`, and `#unset` methods.

I wrote a quick list of tests for each of the methods, including edge cases (setting each type, getting an existing value, getting a non-existing value, changing an existing setting to a different type, etc), and wrote the tests and code in TDD fashion.

I created accessor methods for a virtual `value` attribute to abstract away the datatype handling, allowing the model to be easily used without any knowledge of the actual attributes. To make it easy to support additional data types in the future, I decided to use a hash to map classes to column types (in `#datatype_from_object`). I placed the hash in an initializer (`/config/initializers/global_setting_datatypes.rb`) so it wouldn't be duplicated in memory for each instance of the GlobalSetting class.

The class methods just utilize `#value` and `#value=`, and behave in a way that seemed intuitive.

I employed simple caching in the `::get` method, using the class name and the key, and added `#invalidate_cache` to be triggered as an `after_commit` action.

Lastly, I wrote documentation for the methods, then made sure the tests fully supported the documentation.

Overall, the process took about an hour, plus an additional 20 minutes or so of documentation.

## Prompt

Written by [Tim Heuett](http://github.com/timhugh) as a code sample for [Stella & Dot](http://stelladot.com) based on this prompt:

> Write a model (ActiveRecord-based) for storing global configuration settings. It will be used for storing single values, for example an email address to send error emails to, or a flag enable/disable a particular feature. The interface must be simple and convenient, it should be possible to read and write specific configuration items. It must be possible to store values of these 4 types: string, integer, float and boolean. The model should come with a unit test and a migration.

> Bonus: add caching within the model so that values are cached in regular Rails cache to minimize db load.

> Please include a quick summary of use and commentary regarding any design decisions. Please indicate how long you spent working on this.
