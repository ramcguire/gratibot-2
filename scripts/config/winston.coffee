winston = require('winston')

loggingLevel = process.env.LOGGING_LEVEL or 'info'

winston.configure
  level: loggingLevel
  transports: [ new (winston.transports.Console)(format: winston.format.json()) ]
  exceptionHandlers: [ new (winston.transports.Console)(format: winston.format.json()) ]

module.exports = winston