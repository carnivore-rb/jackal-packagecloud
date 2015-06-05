# Jackal Packagecloud

Jackal service to push packages to packagecloud.

## Configuration

Requires configured api_key / account_name for packagecloud in jackal config

```ruby
  # ...
  jackal do
    packagecloud do
      config do
        api_key ENV['PACKAGECLOUD_API_KEY']
        account_name ENV['PACKAGECLOUD_ACCOUNT_NAME']
      end
    end
  end
```

## Payload structure

```json
{ "data": {
    "packagecloud": {
      "packages": [
        { "distro_description": "ubuntu/precise",
          "path": '/tmp/foo.deb' }]}}}
```

# Info

* Repository: https://github.com/carnivore-rb/jackal-packagecloud
* IRC: Freenode @ #carnivore
