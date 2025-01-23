# BeeminderWithingsSync

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## Outline

End-to-End Test:

1. User visits `/users/log_in`
2. User clicks “Sign in with Beeminder”
    1. They are redirected to https://beeminder.com/apps/authorize and must authorize this app.
3. User is redirected to `/beeminder/auth_callback` with query params: access_token, username
    1. App saves access_token and username to database as BeeminderUserInfo which belongs to User.
4. User is redirected to `/app`
5. User clicks “Sign in with Withings”
    1. They are redirected to https://accounts.withings.com/oauth2_user/authorize2 and must authorize this app.
    2. Need to specify scope, state
6. User is redirected to `/withings/auth_callback` with query params: code, state
    1. App should immediately request tokens using code as an authorization code
        1. POST “https://wbsapi.withings.net/v2/oauth2”
            1. action=requesttoken
            2. grant_type=authorization_code
            3. client_id
            4. client_secret
            5. code
            6. redirect_uri
        2. Resp:
            1. access_token (str)
            2. refresh_token (str)
            3. expires_in (int)
            4. scope (str)
            5. token_type (str)
            6. userid (str)
    2. App saves response to database as WithingsUserInfo which belongs to User.
7. User is redirected to `/app`
8. User creates a new Goal.
    1. Goal types can be:
        1. Do More Measurements
            1. User selects one of many sets of measurement types
                1. (Weight)
                2. (Dia BP, Sys BP, HR)
        2. TODO: Lose Weight (body fat percent, waist size, etc...)
        3. TODO: Gain Weight (lean body mass, bicep diameter, etc...)
    2.  Given a “Do More Measurements” goal, User selects which Withings Measurements they want more of
9. App subscribes to Withings for data notifications
    1. https://developer.withings.com/developer-guide/v3/integration-guide/public-health-data-api/data-api/notifications/notification-content 
10. App periodically gets measurements based on the goal
    1. getmeas can specify meastypes (comma separated list)
    2. App creates data points on that Beeminder goal

### ChatGPT Outline

Below are some areas you may want to confirm or flesh out in more detail. Some of these you may already have implicitly covered, but they’re worth double-checking before you invest too heavily in the integration.

---

## 1. **Beeminder OAuth Details**  
- **Scope:** Confirm whether you need explicit scopes from Beeminder (e.g. “read” vs. “write”) or if Beeminder’s OAuth is broad by default. Ensure you’ll have the correct permissions to create/update goals.  
- **Refresh Tokens:** Does Beeminder’s OAuth return a long-lived access token or do you need to handle refresh tokens? If so, you’ll need to store and periodically refresh them. (Their current API typically provides long-lived tokens, but always good to verify.)  
- **Mapping to Beeminder Goals:**  
  - **Existing Goals vs. Creating New Goals:** If you are creating a new goal via your app, confirm the flow for that (create the goal on Beeminder’s side, store the goal’s slug/ID on your side, etc.).  
  - **Goal Permissions:** Make sure your app’s token can actually push datapoints to that newly created goal.

---

## 2. **Withings OAuth Details**  
- **Scopes:** Withings requires specifying which scopes (e.g. `user.metrics`, etc.) you’ll request. Make sure you request everything you need for daily measurement pulls.  
- **Refresh Token Logic:** Withings tokens expire, so you’ll need to store the refresh token and implement a job or routine to refresh it. Check the `expires_in` you receive in step 6.1.2.  
- **State Parameter Security:** Make sure you’re verifying the `state` in the callback matches what you sent in the authorization request. This helps protect against CSRF-style attacks.

---

## 3. **Sync Logic & Datastore**  
- **Periodic Data Fetches:**  
  1. How often do you fetch measurements? (Hourly? Daily? Both subscription-based notifications plus a fallback cron job?)  
  2. If your plan is purely event/notification-driven, confirm how to handle missed notifications or historical backfill.  
- **Data Models:**  
  - You’ll store `BeeminderUserInfo` and `WithingsUserInfo` as you mentioned.  
  - You’ll also want a local representation of each “Goal” so you can link it to the correct Withings measurement set.  
- **Duplicate Data Points:** Ensure you have a strategy for ignoring duplicates or repeated measurement events from Withings so you don’t send multiple data points for the same measurement to Beeminder.

---

## 4. **Withings Notifications & Callback Handling**  
- **Subscription Endpoint:** Withings needs a URL on your app that they will ping with new measurement data. Make sure you handle:  
  1. **Verification:** Usually Withings will verify your callback endpoint.  
  2. **Security:** Check that requests truly come from Withings (they supply a signature or you can confirm via their recommended method).  
  3. **Data Parsing:** The payload format can include multiple measurement types in one notification.  
  4. **Error Handling:** If your endpoint fails or returns 4xx/5xx, Withings may disable your subscription.

---

## 5. **Handling Edge Cases**  
- **Revoking Access:**  
  - If a user revokes Beeminder or Withings access, how do you detect that scenario and cleanly handle it on your side?  
- **Changing Goals or Measurement Types Mid-Goal:** If a user edits the measurement type for an existing goal, do you handle partial data or re-subscription with Withings (i.e. unsubscribing from old meastypes)?  
- **User Has More Than One Withings Device or Measurement Source** – e.g. scale plus blood pressure monitor. It might not matter, but confirm how your measurement fetch or subscription logic deals with multiple sets of measurements for a single user.

---

## 6. **UI/UX & Next Steps**  
- **User Feedback for Missing Data:** If the user doesn’t measure, do you remind them? Or do you rely on Beeminder’s built-in reminders?  
- **Time Zones & Day Boundaries:** Beeminder goals typically operate on a user-specific “deadline” or “daystart.” If you plan on automatically posting datapoints, be mindful of the user’s local date boundaries. (Beeminder has the concept of “losing a day” at a certain time, e.g. midnight in the user’s local time or another chosen time.)  
- **Manual vs. Automatic Creation of Beeminder Goals:** If your app is generating the goal on the user’s behalf, is that clearly communicated? Or do you instruct the user to create a new goal in Beeminder, then link it?

---

### Final Thoughts
Overall, your end-to-end flow covers the big-picture steps:
1. OAuth with Beeminder  
2. OAuth with Withings  
3. Goal creation (including measurement-type configuration)  
4. Notification subscription (or periodic polling fallback)  
5. Writing datapoints to Beeminder.

Just be sure to handle OAuth details (especially token refresh and revocations), Withings callback verification, edge cases for multiple measurements, and any necessary user experience details around reminders and goal day boundaries.  

Good luck with the integration — you’re already off to a solid start!
