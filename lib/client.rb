require 'httparty'

# Post three users by the name of firstUser, secondUser, and thirdUser respectively
HTTParty.post('http://localhost:3301/users/new', :query => {:name => 'firstUser'})
HTTParty.post('http://localhost:3301/users/new', :query => {:name => 'secondUser'})
HTTParty.post('http://localhost:3301/users/new', :query => {:name => 'thirdUser'})

# List the Users
HTTParty.get('http://localhost:3301/users')

# Delete the user, thirdUser
HTTParty.post('http://localhost:3301/users/thirdUser/messages')

# List the Users
HTTParty.get('http://localhost:3301/users')

# Post a message to secondUser from firstUser
HTTParty.post('http://localhost:3301/users/firstUser/create_message', :query => {:name => 'secondUser', :content => 'Sample message from firstUser to secondUser'})

# Post a message to firstUser from secondUser
HTTParty.post('http://localhost:3301/users/secondUser/create_message', :query => {:name => 'firstUser', :content => 'Sample message from secondUser to firstUser'})

# List the messages for firstUser
HTTParty.get('http://localhost:3301/users/firstUser/messages')

# List the messages for secondUser
HTTParty.get('http://localhost:3301/users/secondUser/messages')

# Delete the message from firstUser to secondUser
HTTParty.post('http://localhost:3301/users/secondUser/messages/1')

# List the messages for secondUser
HTTParty.get('http://localhost:3301/users/secondUser/messages')

# Mark the message from secondUser to firstUser as read
HTTParty.post('http://localhost:3301/users/firstUser/messages/1/read')

# List the messages for firstUser
HTTParty.get('http://localhost:3301/users/firstUser/messages')
