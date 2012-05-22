# To get started on dev:

    # Pull down the repo
    git clone git@github.com:cleanandcreative/oauth_data_proxy.git && cd oauth_data_proxy

    bundle install

    # Install a local config file, which we'll then add values to
    touch config.local.yml
    echo "development:" >> config.local.yml
    echo "  instagram:" >> config.local.yml
    echo "    client_id: ''" >> config.local.yml
    echo "    client_secret: ''" >> config.local.yml
    echo "    access_token: ''" >> config.local.yml
    $EDITOR config.local.yml

    #
    # Now copy client\_id and client_secret from your instagram app [registration page][app_registration]
    #

    # Start the server
    shotgun

### Fetch the Access Token
  
[Go through the login process][login], and copy/paste the returned access_token into the config.local.yml file.

### Get Data
  
[http://localhost:9393/instagram/users/self/feed][feed]

# BOOM!

[app_registration]: http://instagram.com/developer/clients/manage/
[login]: localhost:9393/login
[feed]: http://localhost:9393/instagram/users/self/feed