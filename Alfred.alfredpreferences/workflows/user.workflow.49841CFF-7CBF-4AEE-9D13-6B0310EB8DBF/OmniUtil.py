#!/usr/bin/env python
#-*- coding:UTF-8 -*-
#
# @author  Ritashugisha
# @contact ritashugisha@gmail.com
#
# This file is part of OmniTube.
#
# OmniTube is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# OmniTube is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with OmniTube. If not, see <http://www.gnu.org/licenses/>.

import os, sys, ast, json, subprocess, base64
import plistlib, shutil, tempfile
import urllib, urlparse, webbrowser, requests
import xml.etree.ElementTree as etree
import OmniAuth

"""
.. py:class:: Feedback()
Format Alfred XML feedback.

:param str title: Title of feedback entry
:param str subtitle: Subtitle of feedback entry
:param str arg: Passed argument of feedback entry
:param str valid: yes/no string (must be set to 'yes' (defaults to 'yes'))
:param str autocomplete: empty string (usually set to '')
:param str icon: String path to icon file
"""
class Feedback():
    
    def __init__(self):
        self.feedback = etree.Element('items')
        
    def __repr__(self):
        return etree.tostring(self.feedback)
        
    def add_item(self, title, subtitle = '', arg = '', valid = 'yes', autocomplete = '', icon = 'icon.png'):
        item = etree.SubElement(self.feedback, 'item', uid = str(len(self.feedback)), arg = arg, valid = valid, autocomplete = autocomplete)
        _title = etree.SubElement(item, 'title')
        _title.text = title
        _sub = etree.SubElement(item, 'subtitle')
        _sub.text = subtitle
        _icon = etree.SubElement(item, 'icon')
        _icon.text = icon

"""
.. py:function:: __formatSpaces__(string)
Format a string for console escaping of spaces.

:param str string: String to be formatted
:returns: Formatted string with spaces removed
:rtype: str
"""
def __formatSpaces__(string):
	return string.replace(' ', '\ ')

TITLE         = 'OmniTube'
VERSION       = 4.2
WORKFLOW      = os.path.dirname(os.path.abspath(__file__))
RESOURCES     = '%s/Resources' % WORKFLOW
GLYPHMANAGER  = __formatSpaces__('%s/GlyphManager' % WORKFLOW)
NOTIFIER      = '/Applications/terminal-notifier.app/Contents/MacOS/terminal-notifier'
COCOA         = '/Applications/cocoaDialog.app/Contents/MacOS/cocoaDialog'
ICONS	 	  = '%s/Icons/' % RESOURCES
PKG_MANAGER   = __formatSpaces__('%s/LuxePrisimPackageManager' % WORKFLOW)
DEPENDENCIES  = [{'title':'terminal-notifier', 'dest':'/Applications'}, 
	{'title':'google.chromedriver', 'dest':'%s/webdrivers' % __formatSpaces__(RESOURCES)},
	{'title':'mstratman.cocoadialog', 'dest':'/Applications'}, 
	{'title':'ritashugisha.glyphmanager', 'dest':__formatSpaces__(WORKFLOW)},
	{'title':'ritashugisha.omnitubeicons', 'dest':__formatSpaces__(RESOURCES)}]
SUBSCRIPTIONS = '%s/Subscriptions/' % RESOURCES
OAUTH_JSON    = '%s/oAuth.json' % RESOURCES
DEVELOPER_KEY = 'QUkzOXNpN3RFWGM3dXVYbWNEU255a2pkdWxjOXotY3Q2cC11REdWYURnM0U0MXZwdXRTM1pnSk85WGdUb2JTU3lvWHhiQlVJajBQNXEwaG43bUlkYko1VDFkRWpKR0tIeXc='
CLIENT_ID     = 'NDk0NDY3MDg2NjMxLTZ0cDRrbjk4dGZoNXI5NnAyYTFkNmNlNXUzNm10N2hyLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29t'
CLIENT_SECRET = 'WDNlc3VqVklwWDVsc3pOdVpuMjcxUmoz'
INTRO_HTML    = 'http://www.ritashugisha.co.nf/OmniTube/index.html'
BASE_1        	   = 'https://accounts.google.com/o/oauth2'
BASE_2        	   = 'https://gdata.youtube.com/feeds/api'
BASE_OAUTH         = '%s/auth' % BASE_1
BASE_OAUTH_TOKEN   = '%s/token' % BASE_1
BASE_PROFILE       = '%s/users/default' % BASE_2
BASE_UPLOADS       = '%s/users/default/uploads' % BASE_2
BASE_USER          = '%s/users/%s' % (BASE_2, '%s')
BASE_USER_UPLOADS  = '%s/users/%s/uploads' % (BASE_2, '%s')
BASE_SUBSCRIPTIONS = '%s/users/default/subscriptions' % BASE_2
BASE_FEED          = '%s/users/default/newsubscriptionvideos' % BASE_2
BASE_HISTORY       = '%s/users/default/watch_history' % BASE_2
BASE_VIDEO         = '%s/videos' % BASE_2
BASE_CHANNEL       = '%s/channels' % BASE_2
BASE_USER_PLAYLIST = '%s/users/default/playlists' % BASE_2
BASE_PLAYLIST_FEED = '%s/playlists/%s' % (BASE_2, '%s')
BASE_PLAYLIST      = '%s/playlists/snippets' % BASE_2
BASE_POPULAR       = '%s/standardfeeds/most_popular' % BASE_2
BASE_FAVORITES     = '%s/users/default/favorites' % BASE_2
BASE_WATCHLATER    = '%s/users/default/watch_later' % BASE_2

"""
.. py:function:: __runProcess__(procCmd)
Run a system subprocess (procCmd).

:param str procCmd: System command to be run as subprocess
:returns: Output from system subprocess
:rtype: str
"""
def __runProcess__(procCmd):
	proc = subprocess.Popen([procCmd], stdout = subprocess.PIPE, shell = True)
	(proc, proc_e) = proc.communicate()
	return proc

"""
.. py:function:: __searchAlfred__(query)
Prompt Alfred to search for query (query).

:param str query: Query to search Alfred
"""
def __searchAlfred__(query):
	__runProcess__('osascript -e \'tell application "Alfred 2" to search "%s"\'' % query)

"""
.. py:function:: __urlParse__(url)
Return urlparse object of url.

:param str url: URL to be parsed
:returns: Parsed urlparse object
:rtype: urlparse
"""
def __urlParse__(url):
	return urlparse.urlparse(url)

"""
.. py:function:: displayNotification(title, subtitle, message, execute)
Display a notification using the Notifier application.

:param str title: Title of notification (defaults to TITLE)
:param str subtitle: Subtitle of notification
:param str message: Message of notification
:param str execute: Script to execute on click of notification
"""
def displayNotification(title, subtitle, message, execute):
	notifyCmd = '%s -title "%s" -subtitle "%s" -message "%s" -sender "com.runningwithcrayons.Alfred-2"' % (NOTIFIER, title, subtitle, message)
	if execute:
		notifyCmd = '%s -execute "%s"' % (notifyCmd, execute)
	__runProcess__(notifyCmd)

"""
.. py:function:: cocoaMsgBox(text, informative_text, icon)
Display a message alert using cocoaDialog.

:param str text: Bold text of message box
:param str informative_text: Secondary text of message box
:param str icon: Path to icon file
"""
def cocoaMsgBox(text, informative_text, icon):
	displayCmd = '%s ok-msgbox --title "%s" --text "%s" --informative-text "%s" --icon-file "%s"' % (COCOA, TITLE, text, informative_text, icon)
	return __runProcess__(displayCmd).split('\n')[0] == '1'

"""
.. py:function:: cocoaYesNoBox(text, informative_text, icon)
Display a yes/no box using cocoaDialog.

:param str text: Bold text of message box
:param str informative_text: Secondary text of message box
:param str icon: Path to icon file
"""
def cocoaYesNoBox(text, informative_text, icon):
	displayCmd = '%s msgbox --title "%s" --text "%s" --informative-text "%s" --button1 "Yes" --button2 "No" --icon-file "%s"' % (COCOA, TITLE, text, informative_text, icon)
	return __runProcess__(displayCmd).split('\n')[0] == '1'

"""
.. py:function:: cocoaInputBox(text, icon)
Display a simple input box using cocoaDialog.

:param str text: Bold text of message box
:param str icon: Path to icon file
"""
def cocoaInputBox(text, icon):
	displayCmd = '%s standard-inputbox --title "%s" --informative-text "%s" --icon-file "%s"' % (COCOA, TITLE, text, icon)
	execDisplayCmd = __runProcess__(displayCmd)
	if execDisplayCmd.split('\n')[0] == '1':
		return execDisplayCmd.split('\n')[1]
	else:
		sys.exit(0)
		
"""
.. py:function:: cocoaDropdown(text, items, icon)
Display a simple dropdown dialog using cocoaDialog.

:param str text: Informative text of dialog
:param list items: Array of items
:param str icon: Path to icon file
"""
def cocoaDropdown(text, items, icon):
	items = '" "'.join(items)
	displayCmd = '%s dropdown --title "%s" --text "%s" --button1 "Ok" --button2 "Cancel" --items "%s" --icon-file "%s" --string-output' % (COCOA, TITLE, text, items, icon)
	execDisplayCmd = __runProcess__(displayCmd)
	if execDisplayCmd.split('\n')[0] == 'Ok':
		return execDisplayCmd.split('\n')[1]
	else:
		sys.exit(0)

"""
.. py:function:: jsonLoad(baseUrl)
Get the returned YouTube load from the baseURL query.

:param str baseURL: The URL missing the access_token and the v tags
:param dict param1: Optional extra tags to add to baseURL on jsonLoad (defaults to {})
:returns: json response from YouTube request
:rtype: dict
"""
def jsonLoad(baseURL, param1 = {}):
	import OmniAuth
	if len(param1) > 0:
		return json.loads(urllib.urlopen('%s?access_token=%s&v=%s&alt=json&%s' % (baseURL, 
			OmniAuth.getOAuth()['access_token'], '2', urllib.urlencode(param1))).read())
	else:
		return json.loads(urllib.urlopen('%s?access_token=%s&v=%s&alt=json' % (baseURL, 
			OmniAuth.getOAuth()['access_token'], '2')).read())

"""
.. py:function:: gdataLoad(baseURL, tag1, tag2)
Validate and return the YouTube response feed.

:param str baseURL: Base URL of YouTube request
:param str tag1: First tag of response validation (defaults to 'feed')
:param str tag2: Second tag of response validation (defaults to 'entry')
:param dict param1: Optional extra tags to add to baseURL on jsonLoad (defaults to {})
:returns: json YouTube response feed or false
:rtype: dict/False
"""
def gdataLoad(baseURL, tag1 = 'feed', tag2 = 'entry', param1 = {}):
	if len(param1) > 0:
		gdataResults = jsonLoad(baseURL, param1 = param1)
	else:
		gdataResults = jsonLoad(baseURL)
	if tag1 and tag2:
		if tag1 in gdataResults and tag2 in gdataResults[tag1]:
			return gdataResults['feed']['entry']
		else:
			return False
	else:
		return gdataResults

"""
.. py:function:: getDefaultBrowser()
Retrieve the system's default web browser's name.

:returns: Name of user's default browser
:rtype: str
"""
def getDefaultBrowser():
	defaultBrowser = ''
	try:
		tempLaunchServices = tempfile.mkstemp(suffix = '.plist', dir = os.path.expanduser('/tmp/'))[1]
		shutil.copy('%s/Library/Preferences/com.apple.LaunchServices.plist' % os.path.expanduser('~'), tempLaunchServices)
		subprocess.call(['plutil', '-convert', 'xml1', tempLaunchServices])
		for i in plistlib.readPlist(tempLaunchServices)['LSHandlers']:
			if 'LSHandlerURLScheme' in i and 'http' in i['LSHandlerURLScheme']:
				defaultBrowser = i['LSHandlerRoleAll']
				break
		__runProcess__('rm -rf %s' % tempLaunchServices)
	except:
		defaultBrowser = 'com.apple.safari'
	return defaultBrowser

"""
.. py:function:: retrieveThumb(userID)
Retrieve a channel's thumbnail image and save it to subscriptions folder.

:param str userID: Channel ID to retrieve
"""
def retrieveThumb(userID):
	try:
		urllib.urlretrieve(gdataLoad(BASE_USER % userID, tag1 = '', 
			tag2 = '')['entry']['media$thumbnail']['url'], '%s%s.jpg' % (SUBSCRIPTIONS, userID))
	except ValueError:
		pass		
		
"""
.. py:function:: introHtmlOpen()
Open the intro HTML in the user's default browser.
"""
def introHtmlOpen():
	defaultBrowser = getDefaultBrowser()
	if 'org.mozilla.firefox' in defaultBrowser:
		defaultBrowser = 'Firefox'
	elif 'com.apple.safari' in defaultBrowser:
		defaultBrowser = 'Safari'
	elif 'com.google.chrome' in defaultBrowser:
		defaultBrowser = 'Google Chrome'
	else:
		defaultBrowser = 'Safari'
	__runProcess__('osascript -e \'tell application "%s" to open location "%s"\'' % (defaultBrowser, INTRO_HTML))
	__runProcess__('osascript -e \'tell application "System Events" to set frontmost of process "%s" to true\'' % defaultBrowser)
	
"""
.. py:function:: introLoadThumbs()
During intro, load subscription thumbnails.
"""
def introLoadThumbs():
	gdataResults = jsonLoad(BASE_SUBSCRIPTIONS)
	if 'feed' in gdataResults and 'entry' in gdataResults['feed']['entry']:
		for i in gdataResults['feed']['entry']:
			retrieveThumb(jsonLoad('%s/%s' % (BASE_PROFILE, i['yt$channelId']['$t'])['entry']['author'][0]['yt$userId']['$t']))			
"""
.. py:function:: secondsToHuman(seconds)
Convert an amount of seconds into a human readable time.

:param int seconds: The amount of seconds to be converted
:returns: Human readable time
:rtype: str
"""	
def secondsToHuman(seconds):
	hours = seconds / 3600
	minutes = (seconds % 3600) / 60
	seconds = seconds % 3600 % 60
	result = ''
	if hours > 0:
		result = '%sh' % hours
	if minutes > 0:
		if hours > 0:
			result = '%s ' % result
		result = '%s%sm' % (result, minutes)
	if seconds > 0:
		if hours > 0 and minutes == 0 or minutes > 0:
			result = '%s ' % result
		result = '%s%ss' % (result, seconds)
	return result

"""
.. py:function:: postLoad()
Return the post load for posting methods.

:returns: Dictonary of required headers
:rtype: dict
"""
def postLoad():
	import OmniAuth
	return {'GData-Version':'2',
		'Authorization':'Bearer %s' % OmniAuth.getOAuth()['access_token'],
		'X-GData-Key':'key=%s' % base64.b64decode(DEVELOPER_KEY),
		'Content-Type':'application/atom+xml',
		'Host':'gdata.youtube.com'}

"""
.. py:function:: clearHistory()
Clear the recent viewing history of the authenticated user.
"""
def clearHistory():
	requests.post('%s/watch_history/actions/clear' % BASE_PROFILE,
		data = '<?xml version="1.0" encoding="UTF-8"?>\n<entry xmlns="http://www.w3.org/2005/Atom">\n</entry>',
		headers = postLoad())
	displayNotification(TITLE, 'History Cleared', '', '')

"""
.. py:function:: addPlaylist()
Add a new playlist to the authenticated user's profile.
"""
def addPlaylist():
	playlistTitle = cocoaInputBox('Enter the title of your new playlist:', '%s/icon.png' % WORKFLOW)
	playlistDescription = cocoaInputBox('Enter a description for your new playlist:', '%s/icon.png' % WORKFLOW)
	newpostLoad = postLoad()
	newpostLoad['Content-Length'] = '1'
	requests.post(BASE_USER_PLAYLIST,
		data = '<?xml version="1.0" encoding="UTF-8"?>\n<entry xmlns="http://www.w3.org/2005/Atom"\n\txmlns:yt="http://gdata.youtube.com/schemas/2007">\n<title type="text">%s</title>\n<summary>%s</summary>\n</entry>' % (playlistTitle, playlistDescription),
		headers = newpostLoad)
	displayNotification(TITLE, 'Created new playlist', playlistTitle, '')

"""
.. py:function:: priorityOutput(query)
Final handler for script filter arguments

:param str query: String dictionary to be parsed
"""
def priorityOutput(query):
	if query[0] == '"' and query[-1] == '"':
		query = query[1:-1]
	try:
		query = ast.literal_eval(query)
		if query['key'] == 'wipehistory':
			clearHistory()
		elif query['key'] == 'newplaylist':
			addPlaylist()
		elif query['key'] == 'playlists':
			__searchAlfred__('► playlists')
		elif query['key'] == 'favorites':
			__searchAlfred__('► favorites')
		elif query['key'] == 'watchlater':
			__searchAlfred__('► watchlater')
		elif query['key'] == 'subscriptions':
			__searchAlfred__('► subscriptions')
		elif query['key'] == 'uploads':
			__searchAlfred__('► uploads')
		else:
			webbrowser.open(query)
	except:
		webbrowser.open(query)

"""
.. py:function:: validStart()
Makes sure that the user is authorized, has a valid token, and required files exist before running.
"""	
def validStart():
	if not os.path.exists(RESOURCES):
		__runProcess__('mkdir %s' % __formatSpaces__(RESOURCES))
	if not os.path.exists(OAUTH_JSON):
		__runProcess__('touch %s' % __formatSpaces__(OAUTH_JSON))
	if not os.path.exists('%s/webdrivers' % RESOURCES):
		__runProcess__('mkdir %s' % __formatSpaces__('%s/webdrivers' % RESOURCES))
	if not os.path.exists(SUBSCRIPTIONS):
		__runProcess__('mkdir %s' % __formatSpaces__(SUBSCRIPTIONS))
	requiredInstalls = []
	for i in DEPENDENCIES:
		if not 'True' in __runProcess__('%s --is-installed %s %s' % (PKG_MANAGER, 
			i['title'], i['dest'])).split('\n')[0]:
			requiredInstalls.append(i)
	if len(requiredInstalls) > 0:
		newDependencies = ''
		newDestinations = ''
		for i in requiredInstalls:
			newDependencies = '%s %s' % (newDependencies, i['title'])
			newDestinations = '%s %s' % (newDestinations, i['dest'])
		__runProcess__('%s -i%s -o%s' % (PKG_MANAGER, newDependencies, newDestinations))
	__runProcess__('%s -light -light -dark -dark --suppress' % GLYPHMANAGER)
	import OmniAuth
	OmniAuth.validStart()	

if __name__ in '__main__':
	validStart()	
