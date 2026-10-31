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
- Reusable shift templates with one tap to prefill workplace, times, and break duration
- Clock in and out from the dashboard, with an elapsed timer and a reviewable shift entry at clock-out
- Separate tips, service charge, bonus, and other income entries included in monthly totals
- Daily shift subtotals and weekly hours summaries within the selected month
- Overlap warning before saving a shift that conflicts with another entry
- Editing and undoable deletion for individual shifts and expenses
- Local device storage through `localStorage`
- Search expenses by category, note, payment method, or date, and filter by category

## Current prototype boundary

The app supports Supabase email/password authentication, password recovery, and cloud sync after its migrations are applied. Without the shift templates migration, sign-in and existing cloud data continue working while templates remain local to the device. It keeps a local browser copy, has no realtime multi-device updates, account deletion flow, or payslip entry, and estimates pay at a flat rate.

## Supabase setup

The browser client is configured in supabase-config.js with the project URL and Supabase publishable key. Supabase documents publishable keys for frontend clients; database passwords and secret/service-role keys must stay private. Apply unapplied SQL files in `supabase/migrations/` once and in filename order from the Supabase Dashboard SQL Editor. If the initial schema is already installed, apply `202610310002_shift_templates.sql` and `202610310003_income_entries.sql`; if the template migration is already installed, run only `202610310003_income_entries.sql`. These add template sync and separate-income sync. Set the Auth Site URL and Redirect URLs to https://shift-expense-tracker.vercel.app/ for email confirmation and password recovery. Existing local entries are offered for upload the first time you sign in to an empty cloud account.
