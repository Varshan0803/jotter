# Jotter

A personal notes app (thoughts, to-dos, wishlist) that runs in any browser on your desktop and phone.
Notes are saved in a Supabase database behind your own login, so the same notes show up on every device.

Files:

- `index.html` is the whole app (no build step).
- `config.js` holds your Supabase URL and key.
- `supabase/schema.sql` creates the database table and the security rules.

## 1. Create the database (Supabase, free tier)

1. Sign up at supabase.com and click New project. Pick any name (example: `jotter`) and a database password. Save the password somewhere.
2. Wait about a minute for the project to finish setting up.
3. Open SQL Editor, click New query, paste the contents of `supabase/schema.sql`, and click Run. You should see "Success. No rows returned".

## 2. Connect the app to it

1. In Supabase open Project Settings > API.
2. Copy the Project URL and the anon (or publishable) key.
3. Paste them into `config.js`. Example:

```js
window.JOTTER_CONFIG = {
  supabaseUrl: 'https://abcdxyzcompany.supabase.co',
  supabaseKey: 'eyJhbGciOi...'
};
```

The key is meant to be public. What protects your notes is the row-level security in `schema.sql`: a signed-in user can only read and write rows where `user_id` is their own.

## 3. Try it on your computer first

From the `jotter` folder run:

```
python3 -m http.server 8080
```

Open http://localhost:8080, choose Create an account, and add a note. In Supabase, Table Editor > notes should now show your row.

## 4. Deploy it to your own link

Option A, Vercel (recommended):

1. Create a GitHub repository (example: `jotter`) and push these files to it.
2. At vercel.com choose Add New > Project, import the repo, leave Framework Preset as "Other", leave build settings empty, and click Deploy.
3. You get a link like `https://jotter-varshan.vercel.app`. Open it on your phone and desktop and sign in with the same account.

Option B, Netlify: drag the `jotter` folder onto app.netlify.com/drop.

## 5. Two settings to change in Supabase after deploying

- **Site URL.** Authentication > URL Configuration > Site URL: set it to your deployed link. This is where the confirmation email sends you.
- **Lock signups.** Once your own account exists, go to Authentication > Sign In / Providers and turn off "Allow new users to sign up". This stops strangers from creating accounts on your database. Optionally, turn off "Confirm email" before creating your account if you do not want to wait for a confirmation email.

## How it works

- Signing in uses Supabase Auth with email and password. The session stays on the device, so you sign in once per device.
- Every note change is shown instantly, then written to the database. If a write fails, the app reloads from the database and shows an error message.
- A realtime subscription plus a refresh whenever you return to the tab keeps your phone and desktop in step. Example: add a to-do on your phone, switch to the desktop tab, and it appears within a second or two.
- If `config.js` still has the placeholder values, the app falls back to saving on the current device only.

## Things to know

- Supabase free projects pause after about a week of no activity. Open the Supabase dashboard and click Restore if that happens; your data is kept.
- Back up occasionally: Table Editor > notes > Export to CSV.
