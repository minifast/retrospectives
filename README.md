# README

An application to create retro boards

* Ruby version - 3.1.2
* Rails version - 7.0.0


# Setting up Google

1. Visit the [project on the Google Developer Console](https://console.cloud.google.com/apis/credentials)
2. Create a new Credential > OAuth credential > Web application, and name it after your machine
3. Enter a redirect URL of http://127.0.0.1:3000/users/auth/google_oauth2/callback
4. Copy the Client ID and Secret to your `.env` file as `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET`
