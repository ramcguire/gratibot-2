winston = require "./config/winston"
RecognitionStore = require "./service/recognitionStore"

class Recognition
    constructor: (@sender, @message) ->
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
    addRecipients: () ->
        res = @message.match(@userRegex)
        if res
            for r in res
                if r != '@gratibot'
                    @recipients.push r.substr(1)
        winston.debug("Recipients: [#{@recipients}].")

    # Check if user referenced themselves
    userSelfReferenced: ->
        winston.debug("Sender name: #{@sender.name}, recipient name: #{@recipients}")
        @sender.name in @recipients

    # Calculate recongition description length and verify validity
    descriptionLengthSatisfied: (msgText) ->
        description = msgText.replace(@emojiRegEx, '').replace(@userRegex, '')
        (description.length > @minLength)

module.exports = Recognition
