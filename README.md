# propertyScraping
This project intends to map the rent prices for meter squared in Buenos Aires city. For the moment, only neighbourhood averages are shown. In time, there will be averages for each *radio*, the minimal area break provided by argentine census. Also, for the moment, only Zonaprop site is been taking into acccount. 

## Project's scripts
- *urlToDataset*: is a function that performs webscraping of the Zonaprop site, getting the following variables for each property: adress, neighbourhood, type of operation (sale or rent), type of property (department, house, horizontal property), currency (US Dollars or argentinean pesos) and prize.  

- *urlToDataset*: is a function that takes a url from Zonaprop site and return if the page has no more property adds on it. In that case, the loop in propertyScraping will break.

- *propertyScraping*: this script runs a loop for every type of property  (department, house, horizontal property) and every type of operation (sale or rent), generates every possible url, and runs the *urlToDataset()* function on it. Then sets the date print of the data recollection, and cleans some variables within  

- *neighbourhoodNames*: set the neighbourhoods according to the "official" names as the BA's government consider them in the shapes provided in the city goverment site.

- *rentMap*: taking the dataset with standarized neighbourhood's names, produces a map with the average rent price for meter squared


![rentMapBA](https://github.com/alephcero/propertyScraping/blob/master/rentPrices.jpeg)