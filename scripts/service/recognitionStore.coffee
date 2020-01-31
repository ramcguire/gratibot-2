moment = require 'moment-timezone'
winston = require "../config/winston"

class RecognitionStore
    @giveRecognition: (bot, rec) ->
        bot.brain.data.recognitions ||= {}
        bot.brain.data.recognitionsGiven ||= {}
        for recipient in rec.recipients
            recognitionRecord =
              sender: rec.sender.name
              recipients: rec.recipients
              message: rec.message
              timestamp: rec.timestamp
            winston.debug("recognitonRecord: #{recognitionRecord}")

            winston.debug "#{recipient} is receiving recogniton"

            # Initialize list if empty
            bot.brain.data.recognitions[recipient] ||= []

            # Create recognition
            bot.brain.data.recognitions[recipient].push recognitionRecord
            winston.debug "Created recog"

            bot.brain.data.recognitionsGiven[rec.sender.name] ||= []
            bot.brain.data.recognitionsGiven[rec.sender.name].push recognitionRecord.timestamp
            winston.debug("Rec given: #{bot.brain.data.recognitionsGiven[rec.sender.name].length}")

    @countRecognitionsRecieved: (bot, user, days) ->
        bot.brain.data.recognitions[user] ||= []
        return bot.brain.data.recognitions[user].length # FIX THIS

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

module.exports = RecognitionStore
