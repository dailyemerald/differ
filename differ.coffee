jsdom = require 'jsdom'
fs = require 'fs'
exec = require('child_process').exec

storiesRunning = 0

updateStory = (fullURL, fileName) ->
  jsdom.env fullURL, (err, window) ->
    
    entryContent = window.document.getElementsByClassName('entry-content')[0]

    if entryContent
      story = entryContent.textContent.replace(/\t/g,'') #remove tabs
      fs.writeFile './stories/'+fileName, story, (err) ->
        storiesRunning--
        if err
          console.log err
        else
          console.log fileName, 'saved.'
    else
      storiesRunning--
      console.log fullURL, 'has no .entry-content'

cleanup = ->
    if (storiesRunning == 0)
        clearInterval(cleanupInterval) 
        console.log 'time to rumble'       
        child = exec 'git add . && git commit -a -m "differ" && git push origin master', (error, stdout, stderr) ->
            console.log stdout
            if error not null
                console.log 'error', error
    else     
      console.log(storiesRunning + ' left.')
    return
    
cleanupInterval = setInterval(cleanup, 1000)
       
jsdom.env 'http://www.dailyemerald.com', (err, window) ->
    for url in window.document.getElementsByTagName 'a'
        if url.href.indexOf('dailyemerald.com') isnt -1
            fullURL = url.href
            fileName = url.href.split('.com')[1].replace(/\//g,'_')
            updateStory(fullURL, fileName)
            storiesRunning++