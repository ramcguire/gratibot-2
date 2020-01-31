# Description:
#   Inform the users how to use the bot
#
# Commands:
#   None
#
module.exports = (robot) ->

  emoji = ':fistbump:'

  robot.respond /help\s*(.*)?$/i, (res) ->
    helpText = """
               :wave: Hi there, let's take a look at what I can do!

               **Give Recognition**
               ----
               You can give up to **5** recognitions per day.\n\n


               First, make sure I have been invited to the channel you want to recognize someone in.
               Then, write a brief message describing what someone did, @mention them and include the #{emoji} emoji...I'll take it from there!

               > Thanks <@alice> for helping me fix my pom.xml #{emoji}

               Recognize multiple people at once!

               > <@bob> and <@alice> crushed that showcase! #{emoji}


               The more emojis you add, the more recognition they get.

               > <@alice> just pushed the cleanest code I've ever seen! #{emoji} #{emoji} #{emoji}

               **View Balance**
               ---
               Send me a direct message with `balance` and I'll let you know how many recognitions you have left to give and how many you have received.

               > You have received 0 #{emoji} and you have 5 #{emoji} remaining to give away today
               """
    res.reply helpText
    return


