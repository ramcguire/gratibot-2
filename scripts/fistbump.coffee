# Description:
#   Recognize users with "fistbumps" for achievements
#
# Commands:
#   :fistbump: <@user> <description> - Award fistbumps to a user
#
# Author:
#   gesparza3

winston = require "./config/winston"
Recognition = require "./recognition"
RecognitionStore = require "./service/recognitionStore"

module.exports = (bot) ->

    gratibotEmoji = ':fistbump:'

    # Bot will listen for the :fistbump: emoji in channels it's invited to
    bot.hear /:fistbump:/, (msg) ->
        # Create new Recognition
        rec = new Recognition msg.envelope.user, msg.message.text
        winston.debug("Sender name: #{msg.envelope.user.name}, message text: #{msg.message.text}")

        # Add recipients mentioned in recognition
        rec.addRecipients()
        if not rec.recipients.length
            winston.info("User[#{rec.sender.name}] did not mention any recipient")
            msg.reply "Forgetting something? Try again..." +
              "this time be sure to mention who you want to recognize with `@user`"

        # Check if user is attempting to recognize themselves
        else if rec.userSelfReferenced()
            winston.info("User[#{rec.sender.name}] recognized themself")
            msg.reply "Nice try, but you can't toot your own horn!"

        # Verify message has enough detail
        else if !rec.descriptionLengthSatisfied msg.message.text
            winston.info("Description was too short, recognition not sent")
            msg.reply "Whoops, not enough info! " +
              "Please provide more details why you are giving #{gratibotEmoji}"

        # check recognition count
        todaysRecognitionCount = RecognitionStore.countRecognitionsGivenSince bot, rec.sender, 1
        attemptedCount = todaysRecognitionCount + rec.recipients.length
        winston.debug("ATTEMPTED COUNT: #{attemptedCount}")
        if attemptedCount > 5
            msg.reply "Sorry you can't do that. You've already given #{todaysRecognitionCount} #{gratibotEmoji} today."

        # Message meets requirements, make reccomendation
        else
            winston.info("Valid recognition, #{rec.sender.name} awarding recpient(s)")

            # Store recognition in brain
            RecognitionStore.giveRecognition(bot, rec)

            # Send recognition notification to receipients
            for r in rec.recipients
                bot.messageRoom r, "You've been recognized by @#{rec.sender.name}!"

            # Reply to sender
            bot.messageRoom rec.sender.name, "Your recognition has been sent! " +
                "Well done! You have #{5 - attemptedCount} #{gratibotEmoji} left to give today"
