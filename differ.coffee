jsdom = require 'jsdom'
fs = require 'fs'

updateStory = (fullURL, fileName) ->
  jsdom.env fullURL, (err, window) ->
    entryContent = window.document.getElementsByClassName('entry-content')[0]
    if entryContent
      #console.log fileName, entryContent.textContent
      fs.writeFile './stories/'+fileName, entryContent.textContent, (err) ->
        if err
          console.log err
        else
          console.log fileName, 'saved.'
    else
      console.log fullURL, 'has no .entry-content'

cleanup = ->
    # do git add, commit, push to github
    console.log 'cleanup time!'
    
setTimeout cleanup, 5000
       
jsdom.env 'http://www.dailyemerald.com', (err, window) ->
    for url in window.document.getElementsByTagName 'a'
        if url.href.indexOf('dailyemerald.com') isnt -1
            fullURL = url.href
            fileName = url.href.split('.com')[1].replace(/\//g,'_')
            updateStory(fullURL, fileName)