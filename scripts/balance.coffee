RecognitionStore = require "./service/recognitionStore"

module.exports = (bot) ->

  bot.respond /balance/i, (res) ->

    console.log("Count user id")
    console.log(res.envelope.user.id)
    bal = RecognitionStore.countRecognitionsRecieved bot, res.envelope.user
    given = RecognitionStore.countRecognitionsGiven bot, res.envelope.user
    res.reply "Your balance is #{bal}. You have given #{given}"
