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

## Current prototype boundary

This is a front-end prototype. Data stays in the current browser profile; accounts, server persistence, encrypted sync, real multi-device sessions, account deletion, payslips, recurring bills, and backend security policies are not wired yet. The pay estimate uses a flat hourly rate and rounds the final total to whole rupees, as the plan specifies whole-unit money for its Sri Lankan rupee example. A production version should add an authenticated backend before storing sensitive financial data.
- Search expenses by category, note, payment method, or date, and filter by category.
