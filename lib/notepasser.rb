require "notepasser/version"
require "notepasser/init_db"
require "camping"
require "httparty"
require "pry"

Camping.goes :Notepasser

module Notepasser
end

module Notepasser::Models
  class User < ActiveRecord::Base
    has_many :Message
  end

  class Message < ActiveRecord::Base
    belongs_to :User 
  end
end

module Notepasser::Controllers
  class Index < R '/'
    include HTTParty
    def get
      @welcome_message = "Welcome to the Notepasser Messaging System!"
      @user_link = 'Users Page'
      @create_link = 'Create User'
      render :index
    end
  end

  class ListUsers < R '/users'
    include HTTParty
    def get
      @users = Notepasser::Models::User.select(:name)
      render :user_list
    end
  end

  class AddUser < R '/users/new'
    include HTTParty
    def get
      render :create_user
    end

    def post
      user = Notepasser::Models::User.new(:name => @input.name)
      user.save
      redirect ListUsers
    end
  end

  class ListMessages < R '/users/([^/]+)/messages'
    include HTTParty
    def get(name)
      @number_arr = []
      @read_arr = []
      @user = Notepasser::Models::User.find_by_name(name)
      status = Notepasser::Models::Message.select(:read_status).where(:recipient_id => @user.id).each do |rec|
        @read_arr << rec.read_status
      end
      @content = Notepasser::Models::Message.where(:recipient_id => @user.id)
      message_numbers = Notepasser::Models::Message.select(:message_num).where(:recipient_id => @user.id).each do |rec|
        @number_arr << rec.message_num
      end
      render :message_view
    end

    def post(name)
      user = Notepasser::Models::User.where(:name => name)
      user.destroy_all
      redirect ListUsers
    end
  end

  class AddMessage < R '/users/([^/]+)/create_message'
    include HTTParty
    def get(name)
      render :create_message
    end

    def post(name)
      receiver_id = Notepasser::Models::User.select(:id).where(:name => @input.name).limit(1).to_a.first.id
      message_number = Notepasser::Models::Message.where("recipient_id = #{receiver_id}").count
      message_number += 1
      @message = Notepasser::Models::Message.new(:recipient_id => receiver_id, :message_num => message_number, :content => @input.content, :read_status => false)
      @message.save
      @message_success = 'Message Sent!'
      redirect ListUsers
    end
  end

  class DisplayMessage < R '/users/([^/]+)/messages/(\d+)'
    include HTTParty
    def get(user, number)
      @user = Notepasser::Models::User.find_by_name(user)
      @content = Notepasser::Models::Message.where("recipient_id = #{@user.id} AND message_num = #{number.to_i}").limit(1).to_a.first.content
      @message_number = number
      render :individual_message
    end

    def post(user, number)
      user_id = Notepasser::Models::User.select(:id).where(:name => user).limit(1).to_a.first.id
      message = Notepasser::Models::Message.where("recipient_id = #{user_id} AND message_num = #{number.to_i}")
      message.destroy_all
      redirect ListMessages, user
    end
  end

  class MarkRead < R '/users/([^/]+)/messages/(\d+)/read'
    include HTTParty
    def get(user, number)
      post(user, number)
    end

    def post(user, number)
      user_id = Notepasser::Models::User.select(:id).where(:name => user).limit(1).to_a.first.id
      message_id = Notepasser::Models::Message.select(:id).where("recipient_id = #{user_id} AND message_num = #{number.to_i}").to_a.first.id
      Notepasser::Models::Message.update(message_id, :read_status => true)
      redirect ListMessages, user
    end
  end
end

module Notepasser::Views
  def layout
    html do
      head do
        title { "Notepasser Messaging System" }
      end
      body do
        self << yield
      end
    end
  end

  def index
    p(@welcome_message)
    div do
      a(@user_link, :href => R(ListUsers))
    end
    div do
      a(@create_link, :href => R(AddUser))
    end
  end

  def user_list
    h1 "All Users:"
    if @users.nil? || @users.empty?
      div do
        p 'No Users in the Database!'
      end
      div do
        a 'Create User', :href => R(AddUser)
      end
    else
      ul do
        @users.each do |user|
          li do
            a user.name, :href => R(ListMessages, user.name)
          end
        end
      end
      div do
        a 'Create User', :href => R(AddUser)
      end
    end
  end

  def message_view
    h1 "User - '#{@user.name}' Messages:"
    form :method => :post do
      input :type => 'submit', :name => :name, :value => 'Delete User'
    end
    if @content.nil? || @content.empty?
      p 'No Messages To Display.'
    else
      ol do
        @content.each_with_index do |c, i|
          li do
            div do
              a "Message #{@number_arr[i]}", :href => R(DisplayMessage, @user.name, @number_arr[i])
              if @read_arr[i]
                p "Message #{@number_arr[i]} Read"
              else
                p "Message #{@number_arr[i]} Unread"
              end
            end
          end
        end
      end
    end
    div do
      a 'Create Message', :href => R(AddMessage, @user.name)
    end
  end

  def create_user
    div do
      p 'Enter a new user name:'
      form  :method => :post do
        textarea :name => :name, :rows => '1', :cols => '25'
        input :type => 'submit', :value => 'Submit!'
      end
    end
  end

  def create_message
    h1 'Create Message:'
    div do
      p 'Enter a user for which to send your message (Username) and then enter your message text:'
      form :method => :post do
        textarea :name => :name, :rows => '1', :cols => '25'
        textarea :name => :content, :rows => '20', :cols => '50'
        input :type => 'submit', :value => 'Submit!'
      end
    end
    div do
      p @message_success unless @message_success.nil? || @message_success.empty?
    end
  end

  def individual_message
    form :method => :post do
      input :type => 'submit', :name => :name, :value => 'Delete Message'
    end
    p @content
    div do
      a 'Mark As Read', :href => R(MarkRead, @user.name, @message_number)
    end
  end
end
