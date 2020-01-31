RecognitionStore = require "./service/recognitionStore"

module.exports = (bot) ->

    bot.respond /balance/i, (msg) ->
        room = msg.envelope.user.name
        bal = RecognitionStore.totalRecognitionRecieved bot, msg.envelope.user
        remainder = RecognitionStore.recognitionsLeftToday bot, msg.envelope.user
        bot.messageRoom room,  "Your balance is #{bal}. You have #{remainder} left to give"
