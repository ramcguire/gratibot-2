moment = require 'moment-timezone'
winston = require "../config/winston"

class RecognitionStore
    constructor: (@robot) ->
        @maxRecognitionsPerDay = 5
        storageLoaded = =>
              @storage = @robot.brain.data.gratibot ||= {
                    recognitionsRecieved: {}
                    recognitionsGiven: {}
              }

              @robot.logger.debug "Gratibot Data Loaded: " + JSON.stringify(@storage, null, 2)
        @robot.brain.on "loaded", storageLoaded
        storageLoaded()


    giveRecognition: (bot, rec) ->
        for recipient in rec.recipients
            for f in [1..rec.recognitionFactor]
                recognitionRecord =
                  sender: rec.sender.name
                  recipients: rec.recipients
                  message: rec.message
                  timestamp: rec.timestamp
                winston.debug("recognitonRecord: #{recognitionRecord}")

                winston.debug "#{recipient} is receiving recogniton"

                # Create recognition
                @storage.recognitionsRecieved[recipient] ||= []
                @storage.recognitionsRecieved[recipient].push recognitionRecord
                winston.debug "Created recog"

                @storage.recognitionsGiven[recipient] ||= []
                @storage.recognitionsGiven[rec.sender.name].push recognitionRecord.timestamp
                @robot.brain.save()
                winston.debug("Rec given: #{@storage.recognitionsGiven[rec.sender.name].length}")

    totalRecognitionRecieved: (bot, user) ->
        @storage.recognitionsRecieved[user.name] ||= []
        if @storage.recognitionsRecieved[user.name]
          return @storage.recognitionsRecieved[user.name].length
        return 0

    countRecognitionsRecievedSince: (bot, user, days) ->
        @storage.recognitionsRecieved[user.name] ||= []
        return @storage.recognitionsRecieved[user.name].length

    countRecognitionsGivenSince: (bot, user, days) ->
        @storage.recognitionsGiven[user.name] ||= []
        count = 0
        curDate = moment(Date.now()).tz('America/Los_Angeles')

        startDate = moment(curDate).startOf('day')
        startDate = startDate.subtract(days, 'days')

        winston.debug("User Date: #{curDate}")
        winston.debug("Start Date: #{startDate}")


        if @storage.recognitionsGiven[user.name]
            for recTime in @storage.recognitionsGiven[user.name]
                winston.debug("RecTime: #{recTime}")
                if recTime >= startDate
                    count += 1
        count

    recognitionsLeftToday: (bot, user) ->
        todaysRecognitionCount = @countRecognitionsGivenSince bot, user, 1
        winston.debug "Today's count: #{todaysRecognitionCount} Max: #{@maxRecognitionsPerDay}"

        total = @maxRecognitionsPerDay - todaysRecognitionCount
        return total

module.exports = RecognitionStore
