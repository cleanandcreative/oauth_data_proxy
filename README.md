# Unofficial [Instagram][] Ruby library

This library acts as a client for the [unofficial Instagram API][wiki]. It was used to create [the missing Instagram web interface][web] before [their main API][official] went public.

With it, you can:

* fetch popular photos;
* get user info;
* browse photos by a user.

Caveat: you need to know user IDs; usernames can't be used. However, you can start from the popular feed and drill down from there.

## Example usage

    require 'instagram'
    
    photos = Instagram::popular
    photo = photos.first
    
    photo.caption     #=> "Extreme dog closeup"
    photo.likes.size  #=> 54
    photo.filter_name #=> "X-Pro II"
    
    photo.user.username      #=> "johndoe"
    photo.user.full_name     #=> "John Doe"
    photo.comments[1].text   #=> "That's so cute"
    photo.images.last.width  #=> 612
    
    # available sizes: 150px / 306px / 612px square
    photo.image_url(612)
    # => "http://distillery.s3.amazonaws.com/media/-.jpg" (612×612px image)
    
    # fetch extended info for John
    john_info = Instagram::user_info(photo.user.id)
    
    john_info.media_count    #=> 32
    john_info.follower_count #=> 160
    
    
    # find more photos by John
    photos_by_john = Instagram::by_user(photo.user.id)

To see which models and properties are available, see [models.rb][models].

# Helpful links
* [https://github.com/jrconlin/oauthsimple/blob/master/php/example.php][https://github.com/jrconlin/oauthsimple/blob/master/php/example.php]
* [http://unitedheroes.net/OAuthSimple/][http://unitedheroes.net/OAuthSimple/]
* [https://github.com/mislav/instagram][https://github.com/mislav/instagram]
* [https://github.com/cosenary/Instagram-PHP-API][https://github.com/cosenary/Instagram-PHP-API]
* [https://github.com/macuenca/Instagram-PHP-API][https://github.com/macuenca/Instagram-PHP-API]
* [https://github.com/Phunky/instagram-curl-php/blob/master/instagram-curl.php][https://github.com/Phunky/instagram-curl-php/blob/master/instagram-curl.php]
* [http://marktrapp.com/blog/2009/09/17/oauth-dummies][http://marktrapp.com/blog/2009/09/17/oauth-dummies]


[instagram]: http://instagr.am/
[web]: http://instagram.heroku.com
[wiki]: https://github.com/mislav/instagram/wiki "Instagram API"
[models]: https://github.com/mislav/instagram/blob/master/lib/instagram/models.rb
[official]: http://instagram.com/developer/


