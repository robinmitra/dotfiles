# -*- coding: utf-8 -*-

import re
import urllib
import sys
from workflow import Workflow


def main(wf):
    import requests
    from bs4 import BeautifulSoup as Soup

    if len(wf.args):
        query = wf.args[0]
    else:
        query = None

    urlencoded = urllib.quote_plus(query)
    url = "https://kickass.to/usearch/"+urlencoded+"/"
    r = requests.get(url)

    soup = Soup(r.text)

    rows = soup.find_all("tr", id=re.compile("torrent_*"))
    for row in rows:
        link = row.find("a", class_="cellMainLink")
        arg_link = "http://kickass.to"+link['href']
        seed = [td.string for td in row.find("td", {'class':'green center'})]
        leech = [td.string for td in row.find("td", {'class':'red lasttd center'})]

        wf.add_item(title=link.text,
                    subtitle='Seed : ' + seed[0] + "  -  Leech : " + leech[0],
                    arg=arg_link,
                    valid=True,
                    icon="icon.png")

    wf.send_feedback()

if __name__ == u"__main__":
    wf = Workflow(libraries=['./lib'])
    sys.exit(wf.run(main))
