---
name: translation
description: Write or review the non-English text of a website or app, so it reads as if written by a native speaker and stays consistent with the rest of the product. Use when translating UI strings or page copy into another language, adding a locale, reviewing a translation, or applying a native reviewer's corrections.
---

# Translation

Version 0.1 (2026-10-09). The highwaybus repo keeps its own copy in `.claude/skills/translation`.

A translation is done when a native reader cannot tell it was translated, and the same thing has the same name everywhere in the product. Meaning comes from the source; wording comes from the target language.

The project decides its own words. Before translating, read the project's override file if it names one (look in `AGENTS.md` / `CLAUDE.md`, usually `docs/agents/translation.md`): its glossary, the names that stay in English, and its review sheet format win over this skill.

## Steps

### 1. Collect the product's words

Find where the product already names the things you are about to name (navigation, legal pages, errors, buttons, the same concept on other pages) in each target language, and list them. Reuse them verbatim. A second word for a thing the product already names is a bug, even when both are correct.

Done when every recurring term in the source has its existing translation, or is marked new.

### 2. Translate

Write each language with its rules file open: `languages/<code>.md` in this folder. Read only the files for the languages you are writing. Rules that hold in every language:

- **Meaning, not words.** Translate what the sentence does for the reader. A literal calque that a native would not write is wrong even when every word is right. Trade jargon ("trade desk", "full coach") is translated into what it means.
- **One register for the whole product** in each language, the one its file names. Errors, placeholders and buttons follow it too.
- **One word per concept.** Departure stays departure (never dispatch or pick-up); itinerary, quote, vehicle names are each one word across the page and the product.
- **No English left behind**, except brand and product names, codes (airport codes, ISO codes) and loanwords the language's own copy already uses. When a string is left in English, the reason is the project file or the language file.
- **Proper nouns by local custom.** Places, landmarks and dishes take the name readers of that language know, per the language file. Add the region where a bare name points elsewhere ("Japanese Alps", not "the Alps").
- **Facts survive.** Numbers, units, times, limits and scope stay exactly as in the source; a sentence that narrows or widens the scope ("fees on detours" for "fees, including detours") is a mistranslation.
- **Markup survives.** Placeholders (`{name}`), ICU plural and select syntax, and tags (`<url>…</url>` around the linked words only) stay intact and valid.

Done when every string is translated and matches its language file's checklist.

### 3. Review per language

Review each language in its own sub-agent, in parallel, with a fresh context. Give it the source and target files, the product's words from step 1, this skill's rules, its language file, and the decisions already made (so it does not re-open them). Ask for a JSON list of `key`, `current`, `proposed`, `reason`, and no edits.

Apply what holds up: check each proposal against the source meaning, and reject one that drifts from it. A string shared with another page is fixed on every page that uses it.

Done when every review item is applied or rejected with a reason.

### 4. Hand over

Mark what you wrote as machine-drafted in the project's translation tool, and give the reviewer the project's review sheet. A native review is the only real check; this process lowers what it has to catch.

## Learning from a native review

When a native reviewer corrects a translation, apply the correction, then ask of each one: would it be wrong in any product? If yes, add it to `languages/<code>.md` as a rule or a trap, in the file's existing shape, and bump this skill's version. If it is a product word or a product decision, add it to the project's override file instead. Note the reviewer and date in the language file's history line.
