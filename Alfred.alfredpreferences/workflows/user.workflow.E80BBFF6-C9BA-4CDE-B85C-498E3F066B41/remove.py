from os import path
from types import *
# from sync import rsync
import alp

if len(alp.args()) > 0:
	deletes = alp.args()[0].split('\t')
else:
	print 'Nothing to remove.'
	raise SystemExit
# SCRIPT EXITS

# Sync & load favorites
# rsync(alp.storage('favorites.json'), 'favorites.json')
favs = alp.jsonLoad('favorites.json', default=[])
if type(favs) is DictType:
	favs = favs.values()

if not favs:
	print 'Favorites couldn\'t be located. Nothing removed.'
	raise SystemExit
# SCRIPT EXITS

# Remove non-existent favorites
new_favs = []
for fav in favs:
	if path.exists(fav):
		new_favs.append(fav)
favs = new_favs

# Remove specified entries
deleted = []
for delete in deletes:
	if delete in favs:
		index = favs.remove(delete)
		deleted.append(delete)

# Save & sync new list
alp.jsonDump(favs, 'favorites.json')
# rsync(alp.storage('favorites.json'), 'favorites.json')

# User feedback
if len(deleted) is 0:
	print 'No removable items found. Nothing removed.'
elif len(deleted) is 1:
	print '\'' + path.basename(deleted[0]) + '\' was removed from Favorites.'
elif len(deleted) > 1:
	print str(len(deleted)) + ' items were removed from Favorites.'