# What was going on the day you were born?

This project aims to extract curious information that people might want to know for a particular date.
For instance, people might be interested in what was trending on the day that they were born.
To achieve this, we will be obtaining information about:

- The most profitable movie at the box office from [Box Office Mojo](https://www.boxofficemojo.com/date/?ref_=bo_nb_wly_secondarytab).
- The number one song on the [Billboard Hot 100](https://www.billboard.com/charts/hot-100/).
- The most relevant news of a certain date from both [The Guardian](https://www.theguardian.com/) and [The New York Times](https://www.nytimes.com/).

To collect this information, we will use **web scraping** techniques for movies and music, while fetching data from **APIs** for news sources. 

This repository was produced as the final assignment for the Data Harvesting course in the Master in Computational Social Sciences at Universidad Carlos III de Madrid. It is mantained by [Diego Paroli](https://github.com/parolidiego) and [David Pereiro Pol](https://github.com/davidpereiropol).

## What's inside this repository?

This repository contains:
- A fully replicable script named `what-was-going-on-the-day-you-were-born.Rmd` where we perform and explain the process to get the data that we have obtained.
- A rendered .html version of the same script.
- A folder `data` where we store the databases obtained throughout the project.
- A `shiny_app.R` script where we organize all the data together and display it in a beautiful Shiny App.

## Requirements and step-by-step guide to reproduce our project

In order to reproduce our project it is necessary to have the `RStudio` software installed and obtain an API key from *The Guardian* and *The New York Times*.

Below are step-by-step instructions for obtaining API keys from *The Guardian* and *The New York Times* that must be followed before executing the project.

### Getting started in The Guardian API

#### Registering for getting a developer key

1. First, click [here](https://open-platform.theguardian.com/access/) and press `Register developer key`. 
2. Fill out the required personal details and explain your reason for requesting access. 
3. In the question `Will Guardian content be displayed?` select `Yes`.
4. In the question `If Yes, how will Guardian content be displayed?` select `Other` and write that you are going to display the **headline, the summary and the link**.
5. In `Product name` you can put something like **Cultural Highlights** or the title of our project.
6. After this, you will receive an email and you have to **verify** your account.
8. Finally, you will receive another email and you will get the key.

### Getting started in New York Times API

#### Create an account and sign in

1. Click [here](https://developer.nytimes.com/accounts/create) to `Create an account` on *The New York Times Developers Network*.
2. Enter your data.
3. You will receive an email to **verify** the account.
4. Once that you have verified the account go [here](https://developer.nytimes.com/accounts/login) to `Sign in`.

#### Register apps

1. Select `Apps` from the user drop-down menu.
2. Click `+ New App`.
3. Enter a name and a description.
4. Enable the `Article Search API`.
5. Click `Save`.
6. After that you will get your API key and you have to ensure that the `Status` is active.

### Executing the project

To correctly execute the project you need to:
1. Download or clone the whole repository and then unzip it if necessary.
2. Click on `scraping-cultural-relevance.Rproj` to open it.
3. Once you are inside the R-project you need to open the `what-was-going-on-the-day-you-were-born.Rmd` script (you can do so easily from the bottom right pane).
4. You then need to run that script chunk-by-chunk following the instructions present before each chunk which will guide you on how to:
   -  Safely store your API keys
   -  Set your user agent
   -  Modify the range of data that you want to get
   -  And more
5. Markdown text and code comments will also provide information on what the code is doing and why we structured it that way.
6. Once you get to the last chunk you will see that you can be automatically redirected to the `shiny_app.R` script.
7. If you open and run the `shiny_app.R` script from top to bottom you will be able to execute the Shiny App displaying the results of your scrapers and API calls.

