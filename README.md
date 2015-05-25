# Global Settings Model

Example ActiveRecord model for storing global configuration settings.

## Prompt

Written by [Tim Heuett](http://github.com/timhugh) as a code sample for [Stella & Dot](http://stelladot.com) based on this prompt:

> Write a model (ActiveRecord-based) for storing global configuration settings. It will be used for storing single values, for example an email address to send error emails to, or a flag enable/disable a particular feature. The interface must be simple and convenient, it should be possible to read and write specific configuration items. It must be possible to store values of these 4 types: string, integer, float and boolean. The model should come with a unit test and a migration.

> Bonus: add caching within the model so that values are cached in regular Rails cache to minimize db load.

> Please include a quick summary of use and commentary regarding any design decisions. Please indicate how long you spent working on this.
