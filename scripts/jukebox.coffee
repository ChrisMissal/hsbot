# Description:
#   Let hubot tell you about the office Jukebox.
#
# Commands:
#   hubot dallas whats playing - what's on the jukebox right now
#   hubot dallas pause music - pause playback
#   hubot dallas resume music - resume playback

request_payload = JSON.stringify({"jsonrpc": "2.0", "id": 1, "method": "{0}"})

get_mopidy_url = (office = "dallas") ->
  # todo: add other office urls when they come online; for now it's only Dallas
  "http://jukebox.local:8080/mopidy/rpc"

module.exports = (robot) ->
  robot.respond /(?:(austin|houston|dallas)[- ])?what[']?s playing([- ](.+))?/i, (msg) ->
    mopidy_url = get_mopidy_url(msg.match[1])
    data = request_payload.replace("{0}", "core.playback.get_current_tl_track")

    msg.http(mopidy_url)
      .post(data) (err, res, body) ->
        tl_track = JSON.parse(body).result

        if tl_track.length == 0
          msg.send "I can't tell what's playing on the Jukebox. (shrug)"
                  
        artist_names = (artist.name for artist in tl_track.track.artists)
        msg.send "Now playing #{tl_track.track.name} by #{artist_names.reduce (x, y) -> x + ', ' + y}"


  robot.respond /(?:(austin|houston|dallas)[- ])?pause music/i, (msg) ->
    office = msg.match[1]
    mopidy_url = get_mopidy_url(office)
    data = request_payload.replace("{0}", "core.playback.pause")

    msg.http(mopidy_url)
      .post(data) (err, res, body) ->
        if res.statusCode isnt 200
          msg.send "I can't pause the #{office} jukebox. (shrug)"
          
        msg.send "#{office} jukebox paused."
        

  robot.respond /(?:(austin|houston|dallas)[- ])?resume music/i, (msg) ->
    office = msg.match[1]
    mopidy_url = get_mopidy_url(office)
    data = request_payload.replace("{0}", "core.playback.resume")
    msg.send "Resume " + mopidy_url
    
    msg.http(mopidy_url)
      .post(data) (err, res, body) ->
        if res.statusCode isnt 200
          msg.send "I can't resume the #{office} jukebox. (shrug)"
          
        msg.send "#{office} jukebox resumed."
        
