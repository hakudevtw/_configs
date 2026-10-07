---
name: figma-to-codebase
description: Implement or update a screen or component from a Figma design inside an existing codebase, with the codebase (Tailwind, design tokens, shadcn/ui, other pages) as the source of truth and Figma as a reference. Use for any "implement this Figma", "build this screen from Figma" or "update this page to match the design" request, in place of figma-design-to-code alone.
---

# Figma to codebase

Version 0.5 (2026-10-07). Hand-distributed: if a colleague has an older copy, ask for the version line.

0.4 added what the first full redesign (IPC-106, a long landing page) got wrong: a precedent scan before the plan, a "no new colours, no scaled-up radii, no hand-rolled primitives" rule, structure decisions for aligned parts, and a verification step that compares **images**, not parameters. See **Known failure modes** at the end. 0.5 folds the generic parts of the highwaybus project override into this skill: disagreeing sources, a verification section in the plan, and the hand-off rule.

The codebase is the **source of truth**. Figma is a **reference**: its tokens drift from the code, its structure is uneven, and it carries no annotations. Translate the design into what the codebase already has. Match intent, not pixels. A page built from this skill must look like it belongs to the rest of the site, not like a screenshot of the design.

## Prerequisites

- The Figma MCP is connected, and the Figma plugin's `figma-design-to-code` skill is available. If either is missing, tell the user what is missing and wait.
- Project specifics (token names, component conventions, breakpoints) live in the project's `CLAUDE.md`. Read it first. Where it is silent, read the code: the Tailwind config or CSS theme, `globals.css`, `components/ui`, and two or three existing pages.
- Project docs may add environment-specific rules this skill cannot know: the icon library by name, breakpoint widths, how to start the dev server, how strings are translated, and a hand-off to another workflow. Follow them; they add to this skill and never relax it.
- Figma MCP calls are rate-limited per seat. Budget them: fetch each frame's full-resolution screenshot **once** and slice it locally; fetch design context per section, not per element.

## Flow

Do the steps in order. No file is edited before step 4 ends.

### 1. Classify

Take the Figma node URL and decide: **existing screen** (the page already exists in the code) or **new screen** (it does not). Done when you can name the route or component file for an existing screen, or the closest existing page for a new one.

### 2. Capture the current state and scan precedent

Start the dev server **through the project's sanctioned launcher** and screenshot the existing page at the widths of the design's frames (a phone frame and a desktop frame means two widths). For a new screen, screenshot the closest existing page.

Then scan precedent. For every kind of UI the design contains (card, tab strip, table, badge, button, note/callout, list row, dialog, form), find how **two or three other pages already build it**: which `components/ui` primitive, which radius, which text sizes, how many `className` overrides. Write the findings down; they feed the plan. Done when the screenshots exist, you have looked at them, and each UI kind has a precedent or is marked "none".

### 3. Fetch the design

Invoke `figma-design-to-code` and follow its fetching mechanics: design context, sparse responses, asset download, Code Connect, absolute positioning translated into native layout. **This skill wins every conflict.** Where `figma-design-to-code` makes the design screenshot the target the code must match, or says to implement only from the design context, use the screenshot only as a comparison reference and implement from the codebase. Icons are an exception to its "use the exact SVG asset" rule: follow **Icons** below instead. Done when you hold the design context and the design screenshot.

**Sources that disagree.** Figma, attached images, and tracker comments can disagree. Put each disagreement in plan section 7 and wait for the user's answer. An attached image is a reference until the user names it the target.

**Image assets.** A design image is often a crop of a larger source, with a gradient or mask on top. Use the node's **export** (2x) for any image that is cropped, masked or overlaid in the design; use the raw source only for an image shown whole. Never rebuild a crop from `left`/`width`/`object-position` numbers. Convert to webp and place it where the project keeps images.

### 4. Plan, then wait

Write the plan with these nine sections and present it. Done when the user approves the whole plan. Revise only the sections the user disputes.

If the project docs hand the plan to another workflow for implementation (for example a separate `/implement` skill), stop here: the approved plan is that workflow's spec, and steps 5 and 6 are carried out there. Keep the plan in the conversation, and attach it to the tracker issue only if the user agrees.

1. **Differences**: current screenshot against the design; list only real differences.
2. **Reuse**: for each part of the design, the shadcn/ui or project component that covers it, citing the precedent from step 2. **A plain element where a primitive exists is an exception that needs a reason**, and "it needs overrides" is not one: count the overrides a primitive would need and compare with what the precedent pages use. If the precedent needs three and you expect twelve, you are choosing the wrong primitive or the wrong pattern; say so in section 7.
3. **Downloads**: shadcn components to add (a missing primitive that the design needs, such as a table, is added, not hand-rolled), images with the export/raw choice, non-icon SVGs. Announce them here; fetch after approval. List every icon in the design with the icon chosen for it from the project's icon library (see **Icons**); an icon with no match goes to section 7, not here.
4. **Token map**: every colour, font size, spacing and radius in the design, mapped to a Tailwind class or project token. Mark each "exact" or "nearest".
   - **Colour**: map to the project's **semantic** tokens first (`primary`, `secondary`, `muted`, `success`, `destructive`, `border`, …). Never pick a domain-specific token (for example one named for a feature or a gender) for decoration.
   - **Radius**: use the project's radii as they are. Do **not** scale the radius up to match Figma's pixel values. If the design's radius differs visibly from the precedent pages, that is a design-versus-site question for section 7, not a token to adjust.
   - **Type and spacing**: snap to the project's scale; an arbitrary `text-[Npx]` needs a reason.
5. **New tokens**: the default is **none**. A colour or value with no fit goes to section 7 as "design uses X, the site has no X; nearest semantic tokens are A, B, C", and the user decides. Propose a new token only after the user confirms it is a project-wide addition. Compare colours by how close they look, then by hex.
6. **Primitives**: what will be overridden through `className`, and what would need a change to `components/ui` (needs approval, with the reason). For each primitive, read its source first and list the base classes that will fight the design (fixed heights, radii, overflow, group variants).
7. **Open questions**: unclear structure, missing annotations, design-versus-site differences (colour, radius, shape), sources that disagree, anything that might be project-wide or one-off. When two values on screen describe the same fact and would sit side by side (for example a tab label and the figure under it), do not copy both: pick one source or ask.
8. **Structure**: name the pattern for every part whose pieces must stay aligned, before writing it. A timeline, stepper, tab strip with cards, or a row of equal-height cards each get a decision here (for example: "timeline = compound component; each item draws its own dot and its own segment of the line"; "card rows: content region `flex-1`, bottom block `mt-auto`"; "tab strip: horizontal scroll only, scrollbar hidden"). Parts that must align belong to one component and one box, not to independent absolute coordinates.
9. **Verification**: what step 6 will check, written down now so it can be reviewed. Always include:
   - **Widths**: the design frames' widths, plus the project's breakpoint boundaries (take them from the project docs or the theme).
   - **Longest content**: the longest translated string if the site is multilingual (English is rarely the longest), the longest name, the largest number.
   - **Extreme values**: maximum counts (a two-digit badge), long names, empty lists.
   - **States** the design draws: hover, focus, disabled, open drawers and selects.
   - **Unverifiable parts** (backend data missing, so no result cards): name them now and in the final report.

### 5. Implement

- Check shadcn/ui first. If it has a fitting component, use it. If the project lacks that component, read the latest shadcn docs (the shadcn MCP if connected, otherwise ui.shadcn.com) before writing your own.
- Express every value as a Tailwind class or a project token. A value the plan did not map is a plan gap: stop and ask. No raw palette colours (`green-100`, `slate-500`), no hex.
- Treat `components/ui` as read-only. Style one-off differences by overriding a primitive's `className` at the call site. Change a primitive only for a style the user confirmed is project-wide. If a primitive's own base classes fight yours (a fixed height, a rounded list behind pill triggers), fix it at the call site with the matching variant, and check the result at the edges where backgrounds meet.
- Scroll strips: set both overflow axes (`overflow-x-auto overflow-y-hidden`), hide the scrollbar, and leave room for focus rings.
- Add tokens only as approved in section 5. Put them where the project already defines its tokens.
- Announce any download before running it.
- Touch only the requested screen or component.
- **Dev server**: use the project's launcher (for example `preview_start`), never a shell command. If the port is taken, find out who owns it. Do **not** start a second server against the same build directory: it corrupts the first one's cache. If you need a second, run it from an isolated copy.

## Icons

The project's icon library is the first choice for every icon. Its rules live in the project's own docs (`CLAUDE.md` / `AGENTS.md` and the files they point to); where they name no library, use the icon library the codebase already imports. Do not download an icon SVG from Figma when a library icon fits.

- Pick the library icon closest in shape and meaning to the design's icon. Confirm the component exists in the installed package before using it, and import it by name (no barrel or namespace import).
- If no library icon fits, do not substitute another icon library, redraw the icon, or download the Figma SVG on your own. Stop and ask the user, showing the design icon and the closest library candidates. The user decides.
- Size and colour through Tailwind classes (`size-*`, `text-*`). Do not change an icon's shape.
- A Figma icon shown as a raster image or as part of an illustration is an image, not an icon; handle it under **Downloads**.

### 6. Verify

Verification compares **pictures**. Reading Figma's numbers and checking the code against them does not count.

1. Take the implementation screenshot at the widths of step 2, with the dev server running. Scroll through the page first and wait until every image has loaded; lazy images captured too early look like blank boxes.
2. **Go section by section.** For each section put the design's slice and yours side by side, at the phone and the desktop width, and look. Do not judge from a single full-page thumbnail.
3. In each section check, with a zoomed crop where needed:
   - **Alignment**: dots and lines meet and centre on their labels; equal-height cards share their bottom edges; baselines in a row agree.
   - **Edges**: a container's background does not show past its children's rounded corners; no stray gaps or borders where two pieces meet.
   - **Images**: the visible part matches the design's crop, not just its box.
   - **Overflow**: no horizontal page scroll at the narrowest width; scroll strips scroll on one axis only and show no scrollbar (compare `scrollHeight` and `clientHeight`).
   - **Longest content**: the longest locale, the largest number, the longest name.
4. **Self-review before reporting**: grep the diff for raw palette colours, hex values, arbitrary pixel sizes and radii above the project's, and for primitives with many overrides. Anything left needs a stated reason or a fix.
5. Report each remaining difference and label it **intentional** (mapped to a codebase token or an approved decision) or **to fix**. Fix every in-scope "to fix" item. Record out-of-scope differences that were already there; leave them unchanged. Check hover, focus and disabled states only where the design draws them.

Done when no "to fix" item remains; the user decides pass or fail.

## Known failure modes

Each of these cost a review round on IPC-106. The steps above exist to catch them.

- Hero image used the raw source and a hand-computed crop; the design showed a different crop with a fade baked in. (Step 3, image assets; step 6.3.)
- A pill-shaped tab list sat on a `rounded-lg` list, so its background showed past the pills. (Step 4.6; step 6.3 edges.)
- Equal-height cards had their stat blocks floating at different heights. (Step 4.8; step 6.3.)
- A timeline drew its dots and line as separate coordinates, so they drifted; later the line left a gap above each dot. (Step 4.8.)
- A scroll strip showed a vertical scrollbar. (Step 5; step 6.3.)
- The design's pink was turned into three new colour tokens and, before that, nearly mapped to a gender-specific token. (Step 4.4 and 4.5.)
- Cards, tables and notes were hand-rolled with large radii although the site's pages use `Card`, `Alert` and default radii, and no table primitive had been added. (Step 2 precedent scan; step 4.2, 4.3 and 4.4.)
- A tab label and the duration shown under it came from two sheet tabs that disagreed, and both were copied. (Step 4.7.)
- A second dev server was started against the same build directory and broke the first. (Step 5, dev server.)
