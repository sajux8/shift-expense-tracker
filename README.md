# Shiftly — Shift & Expense Tracker

A mobile-first, installable web app prototype based on Phase 1 of the supplied project plan.

## Run it

Serve this directory over localhost or HTTPS (service workers do not run from `file://`). For example, with Node installed:

```sh
npx serve .
```

Then open the local URL in a browser. Use the browser's install option to add it to a home screen.

## Included

- Responsive dashboard and Home, Shifts, Expenses, and Insights views
- Shift entry with overnight time handling, break subtraction, rate snapshot, tips, and live estimate
- Expense entry with category, date, and note
- Expense payment method tracking and a category spending breakdown
- Monthly totals, activity feed, dark mode, CSV export, full JSON backup and restore, and app-shell service worker
- Multiple workplaces, workplace-specific default hourly rates, and a selectable shift workplace
- Daily shift subtotals and weekly hours summaries within the selected month
- Overlap warning before saving a shift that conflicts with another entry
- Editing and undoable deletion for individual shifts and expenses
- Local device storage through `localStorage`
- Search expenses by category, note, payment method, or date, and filter by category

## Current prototype boundary

The app supports Supabase email/password authentication and cloud sync after the migration is applied. It keeps a local browser copy, has no realtime multi-device updates, account deletion flow, or payslip entry, and estimates pay at a flat rate.

## Supabase setup

The browser client is configured in supabase-config.js with the project URL and Supabase publishable key. Supabase documents publishable keys for frontend clients; database passwords and secret/service-role keys must stay private. Before signing in, apply the SQL migration in supabase/migrations/ from the Supabase Dashboard SQL Editor. Existing local entries are offered for upload the first time you sign in to an empty cloud account.
