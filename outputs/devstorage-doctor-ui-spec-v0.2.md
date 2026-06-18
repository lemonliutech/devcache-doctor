# DevStorage Doctor — UI Specification v0.2

> Visual direction: `Archive Studio`
> 
> This revision replaces the generic dark-dashboard treatment from v0.1 with a more distinctive native macOS utility language.

---

## 1. Design Intent

DevStorage Doctor should feel like a precise desktop instrument for inspecting development storage, not a generic admin console and not a consumer junk cleaner.

The visual system should communicate four ideas clearly:

1. **Measured, not aggressive**  
   The app explains storage before asking the user to delete anything.

2. **Desktop-native, not web-dashboard**  
   It should feel comfortable beside Xcode, Finder, iTerm, and DevEco on macOS.

3. **Structured by storage type**  
   Caches, dependency stores, build artifacts, and package outputs must feel meaningfully different.

4. **Calm authority**  
   The product should look opinionated and trustworthy, especially when warning about medium-risk cleanup.

---

## 2. Visual Direction

### Design Theme

`Archive Studio`

A calm editorial-utility aesthetic with:

- pale graphite app chrome
- warm white working surfaces
- deep ink typography
- moss for safe recovery
- amber for caution
- copper for package-output review

The core metaphor is not “cleaning trash.”  
It is “reviewing generated storage with judgment.”

### What Changes Versus v0.1

- less dark slate, less “ops dashboard”
- fewer boxed panels
- hierarchy built through spacing, typography, and grouped surfaces
- package outputs treated as review-oriented artifacts, not just another deletable row
- top summary becomes a storage narrative, not only a status bar

---

## 3. Color System

### Base Surfaces

```text
--window-bg           #E9E6E1   warm graphite canvas
--sidebar-bg          #DDD9D2   muted chrome
--surface-base        #F6F3EE   primary working surface
--surface-raised      #FCFAF6   raised rows / inspectors
--surface-tint        #F1ECE5   grouped section tint
--surface-strong      #E4DED6   selected / pinned surface
```

### Text

```text
--text-primary        #171717   deep ink
--text-secondary      #5F5A53   warm graphite
--text-muted          #8C857D   subdued metadata
--text-inverse        #FBFAF8
```

### Lines And Structure

```text
--line-subtle         #E4DED6
--line-default        #D4CDC4
--line-strong         #B8AFA4
```

### Semantic Colors

```text
--risk-low            #4E7A61   moss
--risk-medium         #B7772E   amber earth
--risk-high           #9E4B3F   muted oxide
--risk-manual         #8A6642   copper review
--risk-protected      #6C6A66   graphite
--accent-active       #245D66   deep teal
--accent-focus        #2F7480
```

### Usage Rules

- Never rely on color alone; always pair with text and iconography.
- Avoid full-surface semantic fills except in tiny chips, bars, and inline indicators.
- Warnings should feel deliberate, not alarming by default.

---

## 4. Typography

```text
Display / Section headers   SF Pro Display
Body / Data rows            SF Pro Text
Paths / Commands            SF Mono
```

### Scale

```text
11px   metadata, chips
13px   row support text, side labels
15px   body, table rows, controls
18px   section headers
24px   top-line summary values
34px   reclaimable number / major overview value
```

### Tone Rules

- Large numbers should be the only oversized type in the product.
- Headers should be restrained, never “hero” sized.
- Paths and commands use mono only where inspection value matters.

---

## 5. Layout Principles

### Window Structure

Use a full desktop window with three persistent zones:

1. **Left Navigation Rail**
2. **Central Review Workspace**
3. **Right Plan Inspector**

Recommended width split:

```text
Sidebar          220px
Main workspace   fluid, min 760px
Plan inspector   300px
```

### Structural Rules

- No floating dashboard cards across the whole page.
- Group rows into shared surfaces with separators.
- Use one main surface per major section, not a card per item.
- Keep corners tight: 6px to 8px radius maximum.

---

## 6. Information Hierarchy

The central workspace should always read in this order:

1. **Storage story**  
   How much space is used, how much is realistically recoverable, and where the pressure comes from.

2. **Recovery candidates**  
   What is selectable now, grouped by stack and risk.

3. **Protected or review-only items**  
   What is intentionally not auto-cleaned and why.

4. **Operational detail**  
   Command previews, paths, rebuild cost, and exceptions.

This ordering matters.  
The user should feel oriented before they are asked to make cleanup decisions.

---

## 7. Core Components

### 7.1 Storage Story Header

This replaces the old “summary bar” feel.

Structure:

- left: device name, last scan time, storage pressure sentence
- center: large reclaimable estimate
- right: compact breakdown for low / medium / manual review

Example copy:

```text
Macintosh HD is under moderate pressure.
12.8 GB can likely be recovered without touching active SDKs.
```

Visual treatment:

- warm light surface spanning the content width
- one thin usage bar under the sentence
- stacked summary blocks, not decorative charts

### 7.2 Stack Section Header

Each toolchain group should feel like a collapsible archive section.

Content:

- stack icon
- stack name
- item count
- total footprint
- selected count when relevant

Behavior:

- hover reveals subtle tint only
- expanded state uses stronger text, not a giant border

### 7.3 Storage Item Row

Rows should feel like review rows in Finder or a pro asset manager.

Columns:

```text
[selection] [name + one-line explanation] [category] [size] [risk chip] [disclosure]
```

Subtext examples:

- `Rebuildable Xcode build cache`
- `Redownloaded on next pub get`
- `Generated release output; review before deletion`

### 7.4 Category Label

Every row should show one of:

- `Cache`
- `Dependency Store`
- `Build Artifact`
- `Package Output`
- `Protected`
- `Manual Review`

These labels are critical.  
They are the main visual cue that the product understands the difference between caches and generated deliverables.

### 7.5 Risk Chip

Compact, low-noise chip:

```text
[dot] Low
[dot] Medium
[lock] Protected
[archive] Review
```

No loud pills, no saturated tag wall.

### 7.6 Expanded Item Inspector

Expanded rows should reveal a narrow internal inspector, not a separate card.

Fields:

- Path
- Produced by
- Cleanup method
- Rebuild or redownload cost
- Why protected or why review-only
- Possible exceptions

Optional:

- command preview
- `Reveal in Finder`
- `Copy Path`

### 7.7 Cleanup Plan Inspector

The right rail should read like a live audit panel.

Sections:

1. selected items
2. estimated recovery
3. risk mix
4. warnings before execution
5. primary CTA

The right rail should stay narrow and confident.  
It should not become a second app inside the app.

---

## 8. Navigation Model

### Sidebar

Order:

1. Overview
2. Xcode / iOS
3. Android / Gradle
4. Flutter / Dart / FVM
5. Node / pnpm / npm
6. CocoaPods
7. HarmonyOS / DevEco
8. Package Outputs
9. Exceptions
10. Reports
11. Settings

### Sidebar Visual Rules

- active item uses a slim teal rail and a stronger surface tint
- icons remain monochrome by default
- do not color every navigation item by stack

`Package Outputs` deserves its own top-level entry, not just a buried subgroup, because it reflects the product's broader positioning.

---

## 9. Screen Specifications

### Screen A: First Launch

Purpose:

- establish trust
- explain scan boundaries
- request Full Disk Access
- optionally add project roots

Layout:

- centered introduction block
- two stacked setup panels
- one quiet primary action

Tone:

Use language like:

```text
Measure development storage before deciding what to clean.
Nothing is deleted during scan.
```

Avoid a wizard feeling.  
This should feel like a calm setup sheet.

### Screen B: Overview

Purpose:

- answer “where is my space going?”
- separate immediately recoverable space from review-only artifacts

Layout:

1. storage story header
2. grouped results surface
3. package outputs preview strip
4. plan inspector

Special requirement:

Package outputs must appear visually different from caches.  
Recommended treatment:

- use a lighter archival tint
- show filename-oriented rows
- emphasize “last modified” and “project source”

### Screen C: Stack Detail

Purpose:

- let a user understand one ecosystem deeply

For Flutter / Dart / FVM, divide content into:

1. global caches
2. dependency stores
3. project build artifacts
4. package outputs

This screen is where the product proves its intelligence.

For example, one Flutter workspace section may look like:

- `build/` as Build Artifact
- `.dart_tool/` as Build Artifact
- `ios/Pods/` as Dependency Store
- `android/.gradle/` as Dependency Store
- `build/app/outputs/` as Package Output or Manual Review depending on rule confidence

### Screen D: Cleanup Plan

Purpose:

- turn selected rows into an auditable action list

Layout:

- top summary
- ordered actions
- inline warnings
- confirmation CTA

Key design point:

This screen should feel more procedural than analytical.  
The decision was made on the previous screens; here the user is verifying exact actions.

### Screen E: Execution Progress

Purpose:

- show work advancing with confidence

Visual treatment:

- one primary progress indicator
- compact item-by-item execution list
- failed items stay visible in place

Do not over-animate.  
Execution should feel quiet and reliable.

### Screen F: Cleanup Report

Purpose:

- summarize what succeeded
- name what was skipped
- preserve recommendations for manual review

The report should clearly separate:

- cleaned successfully
- skipped because protected
- failed with exception
- package outputs still recommended for review

### Screen G: Exceptions

Purpose:

- make failures first-class and debuggable

Each exception row should show:

- exception name
- operation
- path
- likely cause
- suggested next step

Example exception names:

- `PermissionDenied`
- `FileInUse`
- `ToolUnavailable`
- `PartialCleanup`
- `PathNotFound`

This screen should feel like a precise incident list, not an error dump.

---

## 10. Interaction Model

### Selection Rules

- low-risk items may preselect
- medium-risk items start unselected
- protected and manual-review items cannot enter the cleanup plan directly

### Disclosure Rules

- clicking row body selects the row focus
- clicking chevron opens inline detail
- keyboard navigation should move through rows cleanly

### Hover Rules

- subtle tint only
- utility buttons appear on hover or focus
- no large background flashes

### Confirmation Rules

- low-risk-only plans use standard confirmation
- medium-risk plans require acknowledgment
- future high-risk flows may require item-level confirmation

---

## 11. Microcopy Direction

The product voice should be concise, professional, and slightly reassuring.

Good examples:

- `Rebuildable on next Xcode build`
- `Redownload required on next dependency install`
- `Protected because this SDK appears active`
- `Generated package output; review before deletion`
- `Cleanup failed with PermissionDenied`

Avoid:

- `Boost performance`
- `Junk files`
- `Deep clean`
- `Trash`

---

## 12. Empty, Partial, And Edge States

### No Cleanable Results

Show:

- detected stacks
- scanned paths
- explanation that no known cleanup rule matched

### Partial Scan

Show:

- storage results that succeeded
- a visible partial-scan banner
- link to Exceptions

### No Project Roots

In Flutter and Package Outputs views, show a purposeful empty state:

```text
Project artifacts are scanned only inside folders you add.
[Add Project Root]
```

### Protected-Heavy State

If most large items are protected or manual review, say that plainly.  
Do not imply recoverable space that cannot be acted on.

---

## 13. Design QA Checklist

Before implementing UI from this spec, verify:

- the app does not read like a web admin dashboard
- package outputs are visually distinct from caches
- the overview tells a storage story before presenting controls
- rows are grouped surfaces, not card piles
- the right inspector stays secondary
- the palette avoids purple-heavy or slate-heavy monotony
- warnings feel calm and precise

---

## 14. Recommended Next Translation Into UI

If implemented next, the first screens to prototype should be:

1. First Launch
2. Overview
3. Flutter Stack Detail
4. Cleanup Plan

Those four screens are enough to validate whether the new visual direction actually improves the product.
