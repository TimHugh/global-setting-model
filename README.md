# Global Settings Model

Example ActiveRecord model for storing global configuration settings.

## Usage

The GlobalSetting model supports storage of string, integer, float, and boolean types. By default, anything that does not neatly fit into these categories will be stored as a string.

### Class methods

The GlobalSetting class has three methods, covering the basic CRUD actions. Please view the source comments for full documentation and examples, but here are some brief descriptions:

####::set (key, value)

Using a unique key (expected to be a "stringable" type), a record will be created or updated to store the value parameter.

####::get (key)

Retrieves the value associated with the key param. If no record exists, will return nil.

####::unset (key)

Destroys the record associated with the key param. If no record exists, will return false.

### Instance Methods

GlobalSetting instances have two public methods to abstract the handling of different data types.

#### \#value

Get the value of the current GlobalSetting object.

#### \#value= (value)

Set the value of the current GlobalSetting object. The value will be stored in an appropriate database column based on the class of the value object.

## Approach

First, I thought out the public API. Taking a cue from localStorage in HTML5, I decided a simple key-value pair would be ideal, and the type handling could happen under the hood. This lead to `#set`, `#get`, and `#unset` methods.

Then, I wrote a quick list of tests for each of the methods, including edge cases (setting each type, getting an existing value, getting a non-existing value, changing an existing setting to a different type, etc), and wrote the tests and code in TDD fashion.

I created accessor methods for a virtual `value` attribute to abstract away the datatype handling, allowing the model to be easily used without any knowledge of the actual attributes. To make it easy to support additional data types in the future, I decided to use a hash to map classes to column types (in `#datatype_from_object`). I placed the hash in an initializer (`/config/initializers/global_setting_datatypes.rb`) so it wouldn't be duplicated in memory for each instance of the GlobalSetting class.

After that, the class methods just utilize `#value` and `#value=`, and behave in a way that seemed intuitive.

Finally, I employed simple caching in the `::get` method, using the class name and the key, and added `#invalidate_cache` to be triggered as an `after_commit` action.

Overall, the process took about an hour, plus an additional 20 minutes or so of documentation.

## Prompt

Written by [Tim Heuett](http://github.com/timhugh) as a code sample for [Stella & Dot](http://stelladot.com) based on this prompt:

> Write a model (ActiveRecord-based) for storing global configuration settings. It will be used for storing single values, for example an email address to send error emails to, or a flag enable/disable a particular feature. The interface must be simple and convenient, it should be possible to read and write specific configuration items. It must be possible to store values of these 4 types: string, integer, float and boolean. The model should come with a unit test and a migration.

> Bonus: add caching within the model so that values are cached in regular Rails cache to minimize db load.

> Please include a quick summary of use and commentary regarding any design decisions. Please indicate how long you spent working on this.
