# What was going on the day you were born?

This project aims to extract curious information that people might want to know for a particular date.
For instance, people might be interested in what was trending on the day that they were born.
To achieve this, we will be obtaining information about:

- The most profitable movie at the box office from [Box Office Mojo](https://www.boxofficemojo.com/date/?ref_=bo_nb_wly_secondarytab).
- The number one song on the [Billboard Hot 100](https://www.billboard.com/charts/hot-100/).
- The most relevant news of a certain date from both [The Guardian](https://www.theguardian.com/) and [The New York Times](https://www.nytimes.com/).

To collect this information, we will use **web scraping** for movies and music, while leveraging **APIs** for news sources. Below are step-by-step instructions for obtaining API keys from *The Guardian* and *The New York Times*. 

## Getting started in The Guardian API

### Registering for getting a developer key

1. First, click [here](https://open-platform.theguardian.com/access/) and press `Register developer key`. 
2. Fill out the required details and explain your reason for requesting access. 
3. Put that it is a student project and specify that the content of the Guardian is going to be displayed
4. In the question `If Yes, how will Guardian content be displayed?` select `Other` and write that you are going to display the **headline, the summary and the link**.
5. In `Product name` you can put something like **Cultural Highlights** or the title of this project.
6. After this, you will receive an email and you have to **verify** your account.
8. Finally, you will receive another email and you will get the key.

## Getting started in New York Times API

### Create an account and sign in

1. Click [here](https://developer.nytimes.com/accounts/create) to `Create an account` on *The New York Times Developers Network*.
2. Enter your data.
3. You will receive an email to **verify** the account.
4. Once that you have verified the account go [here](https://developer.nytimes.com/accounts/login) to `sign in`.

### Register apps

1. Select `My Apps` from the user drop-down menu.
2. Click `+ New App`.
3. Enter a name and a description.
4. Enable the `Article Search API`.
5. Click `Save`.
6. After that you will get your API key and you have to ensure that the `Status` is active.
