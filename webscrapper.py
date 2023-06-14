import requests
from bs4 import BeautifulSoup

# Define the URL of the website you want to scrape
url = "https://wikipedia.com"

# send a GET request to the URL
response = requests.get(url)

soup = BeautifulSoup(response.content, 'html.parser')

# find and extract specific data from the HTML
# here's an example of extracting all the links on the page 
links = soup.find_all('a')
for link in links:
    if 'href' in link.attrs:
        print(link['href'])

# you can also find and extract other elements based on their HTML tags, classes, or IDs
# For example, to extract all the paragraph text on the page:
paragraphs = soup.find_all('p')
for p in paragraphs:
    print(p.get_text())

# you can also find and extract text from other HTML elements based on their tags, classes, or IDs
# for example, to extract all the headings on the page:
headings = soup.find_all(['h1', 'h2', 'h3', 'h4', 'h5', 'h6'])
for heading in headings:
    print(heading.get_text())

# additionally, you can extract text from specific elements by their classes or IDs
# for example, to extract the text from an element with a specific class:
specific_element = soup.find(class_='specific-class')
if specific_element:
    print(specific_element.get_text())

# to extract text from an element with a specific ID
specific_element = soup.find(id='specific-id')
if specific_element:
    print(specific_element.get_text())
