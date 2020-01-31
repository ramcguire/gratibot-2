winston = require "../config/winston"

class RecognitionStore
    @giveRecognition: (bot, rec) ->
        bot.brain.data.recognitions ||= {}
        console.log(rec)
        for recipient in rec.recipients
            r =
              sender: rec.sender.id
              recipients: rec.recipients
              message: rec.message
              timestamp: rec.timestamp

            winston.debug "#{recipient} is receiving recogniton"
            recId = bot.brain.usersForFuzzyName(recipient)
            if recId.length is 1
              # Initialize list if empty
              bot.brain.data.recognitions[recId[0].id] ||= []

              # Create recognition
              bot.brain.data.recognitions[recId[0].id].push r
              winston.debug "Created recog"

    @countRecognitionsRecieved: (bot, user, timezone = null, days = null) ->
        bot.brain.data.recognitions[user.id] ||= []
        return bot.brain.data.recognitions[user.id].length

    # @countRecognitionsGiven: (bot, user, timezone, days) ->
    #     count = 0

    #     if timezone and days
    #         userDate = moment(Date.now()).tz(timezone)
    #         midnight = userDate.startOf('day')
    #         midnight = midnight.subtract(days - 1, 'days')

    #         for i of bot.brain.data.recognitions
    #             for j in bot.brain.data.recognitions[i]
    #                 if user.id is j.sender
    #                     if j.timestamp >= midnight
    #                         count += 1

    #     else
    #         for i of bot.brain.data.recognitions
    #             for j in bot.brain.data.recognitions[i]
    #                 if user.id is j.sender
    #                     count += 1

    #     return count

module.exports = RecognitionStore