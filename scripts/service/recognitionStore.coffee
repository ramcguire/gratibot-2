moment = require 'moment-timezone'
winston = require "../config/winston"

class RecognitionStore

    @maxRecognitionsPerDay = 5

    @giveRecognition: (bot, rec) ->
        bot.brain.data.recognitionsRecieved ||= {}
        bot.brain.data.recognitionsGiven ||= {}
        for recipient in rec.recipients
            for f in [1..rec.recognitionFactor]
                recognitionRecord =
                  sender: rec.sender.name
                  recipients: rec.recipients
                  message: rec.message
                  timestamp: rec.timestamp
                winston.debug("recognitonRecord: #{recognitionRecord}")

                winston.debug "#{recipient} is receiving recogniton"

                # Initialize list if empty
                bot.brain.data.recognitionsRecieved[recipient] ||= []

                # Create recognition
                bot.brain.data.recognitionsRecieved[recipient].push recognitionRecord
                winston.debug "Created recog"

                bot.brain.data.recognitionsGiven[rec.sender.name] ||= []
                bot.brain.data.recognitionsGiven[rec.sender.name].push recognitionRecord.timestamp
                winston.debug("Rec given: #{bot.brain.data.recognitionsGiven[rec.sender.name].length}")

    @totalRecognitionRecieved: (bot, user) ->
        bot.brain.data.recognitionsRecieved ||= {}
        bot.brain.data.recognitionsRecieved[user.name] ||= []
        if bot.brain.data.recognitionsRecieved[user.name]
          return bot.brain.data.recognitionsRecieved[user.name].length
        return 0

    @countRecognitionsRecievedSince: (bot, user, days) ->
        bot.brain.data.recognitionsGiven ||= {}
        bot.brain.data.recognitionsGivern[user.name] ||= []
        return bot.brain.data.recognitionsRecieved[user.name].length

    @countRecognitionsGivenSince: (bot, sender, days) ->
        count = 0
        curDate = moment(Date.now()).tz('America/Los_Angeles')

        startDate = moment(curDate).startOf('day')
        startDate = startDate.subtract(days, 'days')

        winston.debug("User Date: #{curDate}")
        winston.debug("Start Date: #{startDate}")


        bot.brain.data.recognitionsGiven ||= {}
        bot.brain.data.recognitionsGiven[sender.name] ||= []
        if bot.brain.data.recognitionsGiven[sender.name]
            for recTime in bot.brain.data.recognitionsGiven[sender.name]
                winston.debug("RecTime: #{recTime}")
                if recTime >= startDate
                    count += 1
        count

    @recognitionsLeftToday: (bot, user) ->
        todaysRecognitionCount = RecognitionStore.countRecognitionsGivenSince bot, user, 1
        winston.debug "Today's count: #{todaysRecognitionCount}"

        total = @maxRecognitionsPerDay - todaysRecognitionCount
        return total

module.exports = RecognitionStore
