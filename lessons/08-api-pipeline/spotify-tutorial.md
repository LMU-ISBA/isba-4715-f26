# Spotify Playlist Generator Tutorial

In class, you called a Weather API by hand and learned the request, parse, loop pattern. This tutorial applies that same pattern to two music APIs: Spotify and Last.fm. By the end, you will have a Python script that searches for an artist, finds related artists, collects their top tracks, and creates a playlist in your Spotify account.

This is an async homework exercise. Work through it at your own pace outside of class.

**Prerequisites:** You need a Spotify account with an active Premium subscription (a free trial works). If you do not have Premium, you can still follow along to practice the pattern. The Weather API exercise from class already covers the core skill.

## Table of Contents

| Step | Topic | What You Will Do |
|------|-------|-----------------|
| 00 | [Create repo and start Claude Code](#step-00-create-github-repo-and-start-claude-code) | Set up the project repo, start Claude Code |
| 01 | [Create a Spotify Developer app](#step-01-create-a-spotify-developer-app) | Register your app, get client ID and secret |
| 02 | [Set up credentials with .env](#step-02-set-up-credentials-with-env) | Store secrets safely with python-dotenv |
| 03 | [Get an access token](#step-03-get-an-access-token) | Walk through the OAuth 2.0 Authorization Code flow |
| 04 | [Search for an artist](#step-04-search-for-an-artist) | Use the Spotify Search API to find an artist ID |
| 05 | [Get a Last.fm API key](#step-05-get-a-lastfm-api-key) | Create an account at last.fm/api |
| 06 | [Get related artists from Last.fm](#step-06-get-related-artists-from-lastfm) | Call artist.getSimilar to find similar artists |
| 07 | [Get top tracks for each artist](#step-07-get-top-tracks-for-each-artist) | Loop: Last.fm artist name to Spotify search to top tracks |
| 08 | [Explore your data](#step-08-explore-your-data) | Build a DataFrame, filter by popularity, save to CSV |
| 09 | [Create a playlist](#step-09-create-a-playlist) | POST to the Spotify create playlist endpoint |
| 10 | [Add tracks to the playlist](#step-10-add-tracks-to-the-playlist) | POST track URIs to the playlist |

---

## Step 00: Open Your Portfolio Project in Cursor

You will build this script inside your portfolio project repo -- the same repo you have been using for your milestone work.

**What to do:**

1. If you have already cloned your portfolio project repo, open it in Cursor. Skip to step 4.

2. If you have not cloned it yet, go to your portfolio project repo on GitHub. Click the green **Code** button, make sure **HTTPS** is selected, and copy the URL.

3. Clone the repo into Cursor. Open a new Cursor window and click **Clone repo** on the welcome screen. Paste the URL you copied. When Cursor asks where to save it, navigate to your `isba-4715` folder. Open the cloned folder when prompted.

4. Open a terminal in Cursor (`` Ctrl+` `` or **Terminal > New Terminal**).

5. Start Claude Code:
   ```bash
   claude
   ```

**Checkpoint:** Your portfolio project repo is open in Cursor. Claude Code is running in the terminal.

---

## Step 01: Create a Spotify Developer App

Before you can call the Spotify API, you need to register an application. This gives you a client ID and client secret, which Spotify uses to identify your app.

**What to do:**

1. Go to [developer.spotify.com/dashboard](https://developer.spotify.com/dashboard/) and log in with your Spotify account.

2. Click **Create app**.

3. Fill in the form:
   - **App name:** anything you want (e.g., `ISBA 4715 Playlist Generator`)
   - **App description:** anything (e.g., `Class project`)
   - **Redirect URI:** type `http://localhost` and click **Add**
   - Check the box to agree to the terms
   - Click **Save**

4. On your app's page, click **Settings**. You will see your **Client ID** on the page. Click **View client secret** to reveal the secret. Copy both values somewhere temporary (a text file, a note). You will paste them into your `.env` file in the next step.

5. While you are in Settings, find your Spotify user ID. Go to [spotify.com/us/account/profile](https://www.spotify.com/us/account/profile/) in a separate tab. Your username (user ID) is listed on the profile page. Copy that too.

**Why the redirect URI matters:** When you authorize your app in Step 03, Spotify will redirect your browser to this URI with an authorization code. Since you are running this locally (not on a web server), `http://localhost` works fine. Your browser will show an error page, but the code you need is in the URL.

**Checkpoint:** You have three values copied: your client ID, client secret, and Spotify user ID.

---

## Step 02: Set Up Credentials with .env

In the Weather API tutorial, you pasted your API key directly into the Python file. That works for a quick exercise, but it means your key ends up in your git history if you commit the file. A `.env` file keeps credentials separate from code. The `.gitignore` you selected during repo setup already excludes `.env` files.

**What to do:**

1. Install `python-dotenv` and the other packages you will need:
   ```bash
   pip install python-dotenv requests pandas
   ```

2. Create a new file called `.env` in your project root. Type the following, replacing the placeholder values with your actual credentials:
   ```
   SPOTIFY_CLIENT_ID=your_client_id_here
   SPOTIFY_CLIENT_SECRET=your_client_secret_here
   SPOTIFY_USER_ID=your_user_id_here
   ```

   Leave the Last.fm key out for now. You will add it in Step 05.

3. Verify that `.env` is listed in your `.gitignore`. Open `.gitignore` and search for `.env`. The Python template should already include it. If it does not, add `.env` on its own line.

4. Create a new file called `spotify.py`. Add the following imports and credential loading:

   ```python
   import requests
   import json
   import pandas as pd
   from urllib.parse import urlencode
   from dotenv import load_dotenv
   import os

   load_dotenv()

   client_id = os.getenv('SPOTIFY_CLIENT_ID')
   client_secret = os.getenv('SPOTIFY_CLIENT_SECRET')
   user_id = os.getenv('SPOTIFY_USER_ID')
   ```

5. Save the file and run it to make sure there are no import errors:
   ```bash
   python spotify.py
   ```

   No output means no errors. If you see `ModuleNotFoundError`, double-check that `pip install` finished without errors.

**Why .env:** Your `.env` file never gets committed. If you share your repo or make it public, your credentials stay on your machine. Compare this to the Weather API exercise where the key was right in the script -- that was fine for a quick in-class demo, but you would not do it for anything you plan to keep.

**Checkpoint:** `spotify.py` runs without errors. Your `.env` file exists in the project root and is gitignored.

---

## Step 03: Get an Access Token

The Weather API used a simple API key: include it as a parameter and you are done. Spotify uses OAuth 2.0, which is more involved but lets you specify exactly what your app can do on behalf of a user.

The OAuth flow works like this:

1. Your script builds a URL. You visit that URL in a browser and log in to Spotify.
2. Spotify redirects your browser to `http://localhost` with an authorization code in the URL.
3. Your script exchanges that code for an access token.
4. You include the access token in the header of every API request.

The token expires after one hour. If your requests start returning 401 errors later in the tutorial, come back to this step and get a fresh token.

**What to do:**

1. Add this code below your credential loading in `spotify.py`:

   ```python
   # --- Step 03: Get an access token ---

   # Build the authorization URL
   auth_params = {
       'client_id': client_id,
       'response_type': 'code',
       'redirect_uri': 'http://localhost',
       'scope': 'playlist-modify-public playlist-modify-private',
   }

   auth_url = f"https://accounts.spotify.com/authorize?{urlencode(auth_params)}"
   print(f"Go to this URL to authorize:\n{auth_url}")

   auth_code = input("Paste the authorization code here: ")
   ```

2. Save and run the script:
   ```bash
   python spotify.py
   ```

   The script prints a long URL. Copy the entire URL and paste it into your browser.

3. Log in to Spotify if prompted, then click **Agree** to authorize your app.

4. Your browser will redirect to something like:
   ```
   http://localhost/?code=AQDk8J...long_string...
   ```
   The page itself will show an error (because nothing is listening on localhost). That is expected. Copy everything after `?code=` in the URL bar. Paste it back into the terminal where the script is waiting and press Enter.

5. Now add the code to exchange the authorization code for an access token. Add this below the `auth_code` line:

   ```python
   # Exchange the authorization code for an access token
   token_url = 'https://accounts.spotify.com/api/token'

   token_data = {
       'grant_type': 'authorization_code',
       'code': auth_code,
       'redirect_uri': 'http://localhost',
       'client_id': client_id,
       'client_secret': client_secret,
   }

   response = requests.post(token_url, data=token_data)
   token_response = response.json()

   access_token = token_response['access_token']
   print(f"Access token received (expires in {token_response['expires_in']} seconds)")

   # Set up the authorization header for all future requests
   auth_headers = {
       "Authorization": f"Bearer {access_token}"
   }
   ```

6. Save and run the script again. Complete the authorization flow. You should see a message confirming the token was received.

**Troubleshooting:**

- **"Invalid redirect URI"** -- Go to your Spotify Developer Dashboard, click your app, click **Settings**, and make sure `http://localhost` is listed under Redirect URIs.
- **401 Unauthorized** -- Your token has expired. Run the script again to get a new one.
- **403 Forbidden** -- Your app does not have the right permissions. Make sure the `scope` parameter includes `playlist-modify-public playlist-modify-private`.

**Why OAuth instead of a simple key:** Spotify needs to know not just which app is calling, but which user is logged in. When you create a playlist later, Spotify needs to know whose account to put it in. OAuth handles that handshake. You will see OAuth again if you work with Google, GitHub, or Salesforce APIs.

**Checkpoint:** Your script prints a confirmation that the access token was received.

---

## Step 04: Search for an Artist

Now you can talk to the Spotify API. Your first real call is the Search endpoint, which finds an artist and returns their Spotify artist ID. That ID is how Spotify uniquely identifies every artist, album, and track in its catalog.

**What to do:**

1. Add this code to `spotify.py`:

   ```python
   # --- Step 04: Search for an artist ---

   artist_name = 'YOUR_FAVORITE_ARTIST_NAME'

   search_url = "https://api.spotify.com/v1/search"

   params = {
       "q": artist_name,
       "type": "artist",
       "limit": 1,
   }

   response = requests.get(search_url, headers=auth_headers, params=params)
   search_results = response.json()

   if search_results['artists']['items']:
       artist_id = search_results['artists']['items'][0]['id']
       print(f"Found: {search_results['artists']['items'][0]['name']} (ID: {artist_id})")
   else:
       print(f"No artist found for '{artist_name}'")
   ```

2. Replace `'YOUR_FAVORITE_ARTIST_NAME'` with an artist you like. Pick someone well-known enough that Spotify and Last.fm both have data on them.

3. Save and run the script. You should see the artist name and their Spotify ID.

**Why limit 1:** The search endpoint can return many matches. Setting `limit` to 1 gives you the best match and keeps the response simple. In a production app you might show the user a list of matches to choose from, but for this script the top result is good enough.

**Checkpoint:** Your script prints the artist name and their Spotify artist ID.

---

## Step 05: Get a Last.fm API Key

You need a second API for related artists. Spotify's own Get Related Artists endpoint was deprecated in early 2025. Last.fm's `artist.getSimilar` still works and returns the same kind of data: a list of artists that fans of your chosen artist also listen to.

**What to do:**

1. Go to [last.fm/api/account/create](https://www.last.fm/api/account/create).
   - If you do not have a Last.fm account, create one first at [last.fm/join](https://www.last.fm/join).

2. Fill in the API account form:
   - **Application name:** anything (e.g., `ISBA 4715`)
   - **Application description:** anything
   - Leave the callback URL blank
   - Click **Submit**

3. You will see an **API Key** and a **Shared Secret**. Copy the API key.

4. Open your `.env` file and add:
   ```
   LASTFM_API_KEY=your_lastfm_api_key_here
   ```

5. In `spotify.py`, add this line right below where you load the other environment variables:
   ```python
   lastfm_api_key = os.getenv('LASTFM_API_KEY')
   ```

6. Save and run the script to make sure there are no errors.

**Checkpoint:** Your `.env` file has four variables: `SPOTIFY_CLIENT_ID`, `SPOTIFY_CLIENT_SECRET`, `SPOTIFY_USER_ID`, and `LASTFM_API_KEY`. Your script loads all four without errors.

---

## Step 06: Get Related Artists from Last.fm

This is where the Weather API pattern shows up again. You build a URL with parameters, call `requests.get()`, parse the JSON response, and pull out the data you need. The only difference is the API and the shape of the response.

**What to do:**

1. Add this code to `spotify.py`:

   ```python
   # --- Step 06: Get related artists from Last.fm ---

   related_artists_url = "http://ws.audioscrobbler.com/2.0/"

   params = {
       'method': 'artist.getsimilar',
       'artist': artist_name,
       'api_key': lastfm_api_key,
       'format': 'json',
   }

   response = requests.get(related_artists_url, params=params)
   related_artists_data = response.json()

   related_artists = related_artists_data['similarartists']['artist']

   print(f"Found {len(related_artists)} related artists")
   print("First 5:")
   for artist in related_artists[:5]:
       print(f"  - {artist['name']}")
   ```

2. Save and run the script. You should see a count of related artists and the first five names.

**Why Last.fm instead of Spotify:** Spotify deprecated its Get Related Artists endpoint in early 2025, so it is no longer available for new apps. Last.fm's `artist.getSimilar` returns similar data and is free. Combining two APIs to get what you need from neither one alone is common in practice, and this is a good example.

**Checkpoint:** Your script prints a list of related artists from Last.fm.

---

## Step 07: Get Top Tracks for Each Artist

This is the core loop. For each related artist, you need to: (1) search Spotify for their artist ID, then (2) get their top tracks. This is the same request-parse-loop pattern from the Weather API, just applied twice in sequence inside the loop.

**What to do:**

1. Add this code to `spotify.py`:

   ```python
   # --- Step 07: Get top tracks for each artist ---

   # Start with the original artist's top tracks
   top_tracks_url = f"https://api.spotify.com/v1/artists/{artist_id}/top-tracks"
   params = {"market": "US"}
   response = requests.get(top_tracks_url, headers=auth_headers, params=params)
   top_tracks = response.json()['tracks']

   print(f"Got {len(top_tracks)} tracks from {artist_name}")

   # Try changing [0:3] to [0:10] -- what happens to your playlist size?
   for related_artist in related_artists[0:3]:
       print(f"  Getting Spotify ID for: {related_artist['name']}")

       # Search Spotify for this artist's ID
       search_url = "https://api.spotify.com/v1/search"
       params = {
           "q": related_artist['name'],
           "type": "artist",
           "market": "US",
           "limit": 1,
       }
       response = requests.get(search_url, headers=auth_headers, params=params)
       search_data = response.json()

       if not search_data['artists']['items']:
           print(f"    Skipping (not found on Spotify)")
           continue

       related_artist_id = search_data['artists']['items'][0]['id']

       # Get top tracks for this related artist
       top_tracks_url = f"https://api.spotify.com/v1/artists/{related_artist_id}/top-tracks"
       params = {"market": "US"}
       response = requests.get(top_tracks_url, headers=auth_headers, params=params)
       related_top_tracks = response.json()['tracks']

       top_tracks.extend(related_top_tracks)
       print(f"    Added {len(related_top_tracks)} tracks")

   print(f"\nTotal tracks collected: {len(top_tracks)}")
   ```

2. Save and run the script. You should see output showing the original artist plus three related artists being processed.

**Why [0:3]:** List slicing (`related_artists[0:3]`) takes the first three items from the list. This keeps the tutorial manageable, but you can experiment. Change it to `[0:10]` and your playlist grows from roughly 40 tracks to over 100. Change it to `[0:1]` and you get just one related artist. The loop does not care how many items it processes; you control the volume with the slice.

**Checkpoint:** Your script collects top tracks from the original artist plus three related artists. Total should be roughly 40 tracks.

---

## Step 08: Explore Your Data

You have a list of track dictionaries in memory. Before creating the playlist, take a moment to put the data into a DataFrame so you can see what you are working with, filter it, and save a copy.

**What to do:**

1. Add this code to `spotify.py`:

   ```python
   # --- Step 08: Explore your data ---

   df = pd.DataFrame(top_tracks)

   print(f"DataFrame shape: {df.shape}")
   print(f"Columns: {list(df.columns)}")
   ```

2. Save and run the script. Check the shape. You should have roughly 40 rows and around 20 columns.

3. Now filter and sort. Add these lines:

   ```python
   # Filter: keep non-explicit tracks with popularity >= 50
   df_filtered = df.query('explicit == False and popularity >= 50')

   # Sort by popularity (most popular first)
   df_filtered = df_filtered.sort_values('popularity', ascending=False)

   print(f"\nAfter filtering: {df_filtered.shape[0]} tracks")
   print("\nTop 10 tracks by popularity:")
   print(df_filtered[['name', 'popularity']].head(10).to_string(index=False))
   ```

4. Save to CSV so you have a record of what went into your playlist:

   ```python
   # Save to CSV
   df_filtered.to_csv('playlist_tracks.csv', index=False)
   print(f"\nSaved {df_filtered.shape[0]} tracks to playlist_tracks.csv")
   ```

5. Save and run the script. Check the output and look at the CSV file.

**Why filter:** The raw track list includes everything: explicit tracks, deep cuts with low popularity scores, duplicates. Filtering lets you shape the playlist before you create it. If you think of this in pipeline terms, filtering is the transformation step between raw extraction and final output.

**Checkpoint:** You have a `playlist_tracks.csv` file and the script prints the top 10 tracks by popularity.

---

## Step 09: Create a Playlist

Now you will write data back to Spotify. Everything up to this point used GET requests (reading data). Creating a playlist is a POST request (writing data). The structure is similar, but you send a JSON body instead of query parameters.

**What to do:**

1. Add this code to `spotify.py`:

   ```python
   # --- Step 09: Create a playlist ---

   playlist_name = f'{artist_name} Mixtape'
   playlist_description = f'Generated with Python using artists related to {artist_name}'

   playlist_url = f"https://api.spotify.com/v1/users/{user_id}/playlists"

   playlist_body = json.dumps({
       'name': playlist_name,
       'description': playlist_description,
       'public': False,
   })

   response = requests.post(playlist_url, headers=auth_headers, data=playlist_body)
   playlist_data = response.json()

   playlist_id = playlist_data['id']
   print(f"Created playlist: {playlist_name}")
   print(f"Playlist ID: {playlist_id}")
   ```

2. Save and run the script. You should see the playlist name and ID printed.

3. Open Spotify (the app or web player). You should see the new playlist in your library. It will be empty for now.

**Why POST instead of GET:** GET reads data. POST writes data. Searching for an artist is asking Spotify a question (GET). Creating a playlist is telling Spotify to make something (POST). You will see this same split in every REST API.

**Checkpoint:** Your script prints the new playlist ID. The empty playlist appears in your Spotify library.

---

## Step 10: Add Tracks to the Playlist

The playlist exists but has no tracks. You need to send the track URIs (Spotify's internal identifiers for tracks) to the playlist's items endpoint.

**What to do:**

1. Add this code to `spotify.py`:

   ```python
   # --- Step 10: Add tracks to the playlist ---

   # Get the track URIs from the filtered DataFrame
   track_uris = df_filtered['uri'].tolist()

   # Add tracks to the playlist
   add_tracks_url = f"https://api.spotify.com/v1/playlists/{playlist_id}/items"

   add_tracks_body = json.dumps({
       "uris": track_uris
   })

   response = requests.post(add_tracks_url, headers=auth_headers, data=add_tracks_body)
   add_tracks_data = response.json()

   print(f"Added {len(track_uris)} tracks to '{playlist_name}'")
   print(f"Open Spotify and check your playlist!")
   ```

2. Save and run the script one final time. Complete the full authorization flow and let the script run through all the steps.

3. Open Spotify. Your playlist should now have tracks in it. Press play.

**Checkpoint:** Your playlist in Spotify has tracks. You can play it.

---

## Commit and Push

Your playlist generator is complete. Time to save your work.

**What to do:**

1. In Claude Code, type:
   ```
   Commit all files and push to GitHub.
   ```

2. Make sure your `.env` file is NOT included in the commit. Claude Code should respect the `.gitignore`, but double-check the commit output.

3. Verify on GitHub that your repo contains `spotify.py` and `playlist_tracks.csv` but does NOT contain `.env`.

**Checkpoint:** Your repo is pushed to GitHub and visible at your repository URL. No credentials are in the commit history.

---

## Submission

This tutorial is part of Lesson Exercises 08. Completing it reinforces the API pattern you will use in your portfolio project.

Push your portfolio project repository to GitHub and submit the repo URL.

Your repo should contain:
- `spotify.py` -- your API script with OAuth, search, loop, filter, and playlist creation
- `playlist_tracks.csv` -- the exported track data
- `.gitignore` -- Python gitignore (should include `.env`)

Your repo should NOT contain:
- `.env` -- your credentials file (must be gitignored)
