---
name: figma-to-codebase
description: Implement or update a screen or component from a Figma design inside an existing codebase, with the codebase (Tailwind, design tokens, shadcn/ui) as the source of truth and Figma as a reference. Use for any "implement this Figma", "build this screen from Figma" or "update this page to match the design" request, in place of figma-design-to-code alone.
---

# Figma to codebase

Version 0.1 (2026-10-05). Hand-distributed: if a colleague has an older copy, ask for the version line.

The codebase is the **source of truth**. Figma is a **reference**: its tokens drift from the code, its structure is uneven, and it carries no annotations. Translate the design into what the codebase already has. Match intent, not pixels.

## Prerequisites

- The Figma MCP is connected, and the Figma plugin's `figma-design-to-code` skill is available. If either is missing, tell the user what is missing and wait.
- Project specifics (token names, component conventions, breakpoints) live in the project's `CLAUDE.md`. Read it first. Where it is silent, read the code: the Tailwind config or CSS theme, `globals.css`, `components/ui`, and two or three existing pages.

## Flow

Do the steps in order. No file is edited before step 4 ends.

### 1. Classify

Take the Figma node URL and decide: **existing screen** (the page already exists in the code) or **new screen** (it does not). Done when you can name the route or component file for an existing screen, or the closest existing page for a new one.

### 2. Capture the current state

Start the dev server and screenshot the existing page at the widths of the design's frames (a phone frame and a desktop frame means two widths). For a new screen, screenshot the closest existing page. Done when the screenshots exist and you have looked at them.

### 3. Fetch the design

Invoke `figma-design-to-code` and follow its fetching mechanics: design context, sparse responses, asset download, Code Connect, absolute positioning translated into native layout. **This skill wins every conflict.** Where `figma-design-to-code` makes the design screenshot the target the code must match, or says to implement only from the design context, use the screenshot only as a comparison reference and implement from the codebase. Done when you hold the design context and the design screenshot.

### 4. Plan, then wait

Write the plan with these seven sections and present it. Done when the user approves the whole plan. Revise only the sections the user disputes.

1. **Differences**: current screenshot against the design; list only real differences.
2. **Reuse**: shadcn/ui and existing project components, each mapped to the part of the design it covers.
3. **Downloads**: shadcn components to add, images, SVGs. Announce them here; fetch after approval.
4. **Token map**: every colour, font size, spacing and radius in the design, mapped to a Tailwind class or project token. Mark each "exact" or "nearest".
5. **New tokens**: for each value with no fit, propose a name and value, and offer the one to three nearest existing tokens as alternatives. Compare colours by how close they look, then by hex.
6. **Primitives**: what will be overridden through `className`, and what would need a change to `components/ui` (needs approval, with the reason).
7. **Open questions**: unclear structure, missing annotations, anything that might be project-wide or one-off.

### 5. Implement

- Check shadcn/ui first. If it has a fitting component, use it. If the project lacks that component, read the latest shadcn docs (the shadcn MCP if connected, otherwise ui.shadcn.com) before writing your own.
- Express every value as a Tailwind class or a project token. A value the plan did not map is a plan gap: stop and ask.
- Treat `components/ui` as read-only. Style one-off differences by overriding a primitive's `className` at the call site. Change a primitive only for a style the user confirmed is project-wide.
- Add tokens only as approved in section 5. Put them where the project already defines its tokens.
- Announce any download before running it.
- Touch only the requested screen or component.

### 6. Verify

Screenshot the implementation at the same widths as step 2, with the dev server running. Place it beside the **before** screenshot and the **design** screenshot. Report each remaining difference and label it **intentional** (mapped to a codebase token) or **to fix**. Fix every in-scope "to fix" item. Record out-of-scope differences that were already there; leave them unchanged. Check hover, focus and disabled states only where the design draws them. Done when no "to fix" item remains; the user decides pass or fail.
