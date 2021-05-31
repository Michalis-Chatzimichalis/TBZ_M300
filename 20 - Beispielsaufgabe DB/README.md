```ruby
Vagrant.configure("2") do |config|
```
The "2" in the first line above represents the version of the configuration object config that will be used for configuration for that block (the section between the do and the end). This object can be very different from version to version.

Currently, there are only two supported versions: "1" and "2". Version 1 represents the configuration from Vagrant 1.0.x. "2" represents the configuration for 1.1+ leading up to 2.0.x.


```ruby
```