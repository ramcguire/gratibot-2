# Description:
#   Recognize users with "fistbumps" for achievements
#
# Commands:
#   :fistbump: <@user> <description> - Award fistbumps to a user
#
# Author:
#   gesparza3

winston = require "./config/winston"
RecognitionStore = require "./service/recognitionStore"

class Recognition
  constructor: (@sender, @message) ->
    @cache = {}

    # Pattern to discover users in message
    @userRegex = /@([a-zA-Z0-9]+)/g

    # Pattern to discover emojis in message
    @emojiRegEx = /:(\S+):/

    # Minimum number of characters needed to send recognition
    @minLength = 20

    # List of users mentioned in the recognition
    @recipients = []

    # Time recognition was sent
    @timestamp = new Date()

  # Add recpients from the incoming message
  addRecipients: (bot) ->
    res = @message.match(@userRegex)
    if res
      for r in res
        @recipients.push r.substr(1)
      winston.debug("Recipients regex: [#{@recipients}]. Length is #{res.length}")

  # Check if user referenced themselves
  userSelfReferenced: ->
    winston.debug("Sender name: #{@sender.name}, recipient name: #{@recipients}")
    "@" + @sender.name in @recipients

  # Calculate recongition description length and verify validity
  descriptionLengthSatisfied: (msgText) ->
    description = msgText.replace(@emojiRegEx, '').replace(@userRegex, '')
    (description.length > @minLength)

  # Message for no recognizable users in message
  noRecipientsSpecifiedReply: ->

  # Message for user who tried to award themeselves
  selfReferenceReply: ->
    "Nice try `#{@sender.name}`, but you can't toot your own horn!"

  increaseMessageLengthReply: ->
    "Whoops, not enough info!" +
    "Please provide more details why you are giving :fistbump:"

  # Message for successful recogition
  sentRecognitionReply: ->
    "Your recognition has been sent to #{@recipients}." +
    "Well done! You have [] left to give today"


module.exports = Recognition
