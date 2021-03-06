# Description:
#   Listens for words and sometimes replies with beer related insight.

odds  = [1...100]

quips = [
	"In wine there is wisdom, in beer there is freedom, in water there is bacteria",
	"Hello? Is it beer you're looking for?",
	"Keep calm, it's beer o'clock",
	"(dosequis) I don't always drink beer, just kidding, or course I do.",
	"Beauty is in the eye of the beer holder",
	"Always do sober what you said you'd do drunk. That will teach you to keep your mouth shut.",
	"24 hours in a day, 24 beers in a case. Coincidence?",
	"Alcohol: the cause of, and solution to, all of life's problems.",
	"(beer)",
	"(shiner)",
	"(lonestar)",
	""
]

module.exports = (robot) ->
	robot.hear /(^|\s)beer(\s|$|[\W])/ig, (msg) ->
		val = msg.random odds
		if val > 40
			msg.send msg.random quips

	robot.hear /(^|\s)coffee(\s|$|[\W])/ig, (msg) ->
		val = msg.random odds
		if val > 80
			msg.send "Coffee? How about a beer? (beer)"
