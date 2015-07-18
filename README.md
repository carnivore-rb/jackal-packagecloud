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

Package assets are fetched from the configured asset store requiring
the asset store to be configured and available in running service.

## Payload structure

```json
{
  "data": {
    "packagecloud": {
      "packages": [
        {
          "distro_description": "ubuntu/precise",
          "path": "asset_store/key/path/foo.deb",
          "repo": "my_repo"
        }
      ]
    }
  }
}
```

# Info

* Repository: https://github.com/carnivore-rb/jackal-packagecloud
* IRC: Freenode @ #carnivore
