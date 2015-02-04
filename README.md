# Notepasser

Pass notes to your friends with HTTP and ruby!

## Usage

Run `bundle exec camping -s webrick -h YOUR_IP_ADDRESS lib/notepasser.rb`
to get the server running. Have your friends write a client to send you
messages with HTTParty. Add a short two to three line decription to this
file's "API Calls" section whenever you add support for an API call.

The description should include the HTTP method to use,
the route, and any parameters and what they do.

## API Calls

If API calls aren't your thing - after starting the webrick server with the chosen ip address, just open a browser and hit that ip with port :3301 on the index page to start work from the webview. Example:

```
http://localhost:3301/
```

***Examples of each call using the HTTParty gem***

**get /users**

Returns a list of users from the Users table in the database

```ruby
HTTParty.get('http://localhost:3301/users')
```

**post /users/new**

Posts a new user to the Users table in the database with the chosen 'user_name' attribute

```ruby
HTTParty.post('http://localhost:3301/users/new', :query => {:name => '<user_name>'})
```

**get /users/'user_name'/messages**

Returns a list of messages for the specified user from the Messages table in the database

```ruby
HTTParty.get('http://localhost:3301/users/<user_name>/messages')
```

**post /users/'user_name'/messages**

Deletes the specified 'user_name' from the Users table in the database

```ruby
HTTParty.post('http://localhost:3301/users/<user_name>/messages')
```

**post /users/'user_name'/create_message**

Posts a message from the specified 'user_name' to the specified 'recipient_name' with the text 'content'

```ruby
HTTParty.post('http://localhost:3301/users/<user_name>/create_message', :query => {:name => '<recipient_name>', :content => '<content>'})
```

**post /users/'user_name'/messages/'message_number'**

Deletes the message under 'message_number' for the specified 'user_name'

```ruby
HTTParty.post('http://localhost:3301/users/<user_name>/messages/<message_number>')
```

**post /users/'user_name'/messages/'message_number'/read**

Posts an update to the Messages table in the database that marks the message under 'message_number' for the specified 'user_name' as read

```ruby
HTTParty.post('http://localhost:3301/users/<user_name>/messages/<message_number>/read')
```
