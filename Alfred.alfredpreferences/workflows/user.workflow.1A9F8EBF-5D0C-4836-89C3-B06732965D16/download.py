# -*- coding: utf-8 -*-

import sys
from workflow import Workflow


def main(wf):
    import requests
    from bs4 import BeautifulSoup as Soup

    if len(wf.args):
        query = wf.args[0]
    else:
        query = None

    r = requests.get(query)
    soup = Soup(r.text)
    btn = soup.find("a", class_="verifTorrentButton")
    href = btn['href']
    simple_href = href.split('?')[0]

    print str(simple_href)

if __name__ == u"__main__":
    wf = Workflow(libraries=['./lib'])
    sys.exit(wf.run(main))
