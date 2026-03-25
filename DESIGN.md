# Design System Strategy: The Tactile Social Ledger

## 1. Overview & Creative North Star
The Creative North Star for this system is **"The Digital Concierge."** 

Moving beyond the sterility of basic fintech apps, this design system treats social event planning as a premium, shared experience. We reject the "flat grid" in favor of a **Layered Editorial** aesthetic. By utilizing intentional asymmetry, varying typographic scales, and physical depth, we transform a utility (splitting costs) into a social ritual. The interface should feel like a stack of high-end invitations—organized, effortless, and tangibly premium. We break the "template" look by using overlapping glass surfaces and heavy breathing room (whitespace) to guide the eye toward collective action.

---

## 2. Colors: Tonal Depth vs. Structural Lines
Color is not just for branding; it is our primary tool for defining space.

### The "No-Line" Rule
**Strict Mandate:** Designers are prohibited from using 1px solid borders to section content. Boundaries must be defined solely through background color shifts. Use `surface_container_low` for the base page and `surface_container_highest` or `surface_container_lowest` for cards. This creates a "soft edge" that feels integrated rather than boxed in.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers. 
- **Layer 0 (Base):** `surface` (#f9f9ff)
- **Layer 1 (Page Sections):** `surface_container_low` (#f1f3fe)
- **Layer 2 (Interactive Cards):** `surface_container_lowest` (#ffffff)
- **Layer 3 (Modals/Overlays):** Glassmorphism using `surface` at 70% opacity with a 20px backdrop blur.

### The "Glass & Gradient" Rule
To elevate active states beyond a flat hex code:
- **CTAs:** Use a subtle vertical gradient from `primary` (#0058bc) to `primary_container` (#0070eb).
- **Sticky Elements:** The bottom "Join Event" button must use a glassmorphic container (`surface_bright` at 60% opacity) to allow the content scroll to bleed through, maintaining a sense of environment.

---

## 3. Typography: Editorial Authority
We pair **Manrope** (Display/Headlines) with **Inter** (Body/UI) to balance character with utility.

- **The Hero Scale:** Use `display-lg` for event titles to create an editorial feel.
- **Financial Clarity:** Cost information (e.g., '10k IDR / pax') should utilize `title-lg` with `primary` coloring. This ensures the most vital data "pops" without needing a bold weight.
- **Visual Hierarchy:** 
    - **Manrope (Headline-MD):** Used for "The Vibe"—event names and group titles.
    - **Inter (Body-MD):** Used for "The Details"—descriptions and logbook entries.
    - **Inter (Label-MD):** Used for "The Metadata"—status tags and timestamps, always in `on_surface_variant`.

---

## 4. Elevation & Depth
We eschew traditional shadows in favor of **Tonal Layering**.

- **The Layering Principle:** Place a `surface_container_lowest` card on a `surface_container_low` background. This creates a natural "lift" based on color value alone.
- **Ambient Shadows:** When a card must float (e.g., an active event card), use a shadow with a 32px blur, 0px spread, and 6% opacity of the `on_surface` color. It should feel like a soft glow, not a hard drop.
- **The "Ghost Border" Fallback:** If accessibility requires a container edge, use `outline_variant` at 15% opacity. Never use a 100% opaque border.
- **Glassmorphism:** All sticky navigation or floating action buttons must use `surface_container_lowest` with a 70% alpha and a `blur(12px)` effect.

---

## 5. Components

### Buttons (The "Springy" Interaction)
- **Primary:** Gradient (`primary` to `primary_container`), `xl` (1.5rem) roundedness. Interactions must use a `spring(1, 0.8, 0.5)` animation on press, scaling the button to 0.96x.
- **Secondary:** `secondary_container` background with `on_secondary_container` text. No border.

### Chips (The Social Tag)
- **Selection Chips:** Use `surface_container_highest` for inactive and `primary` for active. Roundedness should be `full` to mimic the "pill" look of iOS.

### Input Fields
- **Modern Inputs:** No bottom line or box. Use a `surface_container_high` background with `md` (0.75rem) corners. The label should be `label-md` floating above the container.

### Cards & Lists (The Divider Ban)
- **Lists:** Forbid the use of divider lines between event participants or cost items. Instead, use a `spacing-4` (1rem) vertical gap or alternating subtle background shifts between `surface_container_low` and `surface_container_lowest`.
- **Event Cards:** Overlapping imagery (avatars) should have a 2px "halo" using the background color of the card to create depth without lines.

### Tooltips & Modals
- **Modals:** Must slide up from the bottom using a "springy" transition. The handle at the top should be a `surface_variant` pill, subtly recessed.

---

## 6. Do's and Don'ts

### Do:
- **Use Asymmetry:** Place the "Total Cost" off-center or in a larger scale to break the monotony of a standard list.
- **Prioritize Motion:** Every tap should have a "spring" response. If it doesn't move, it feels broken.
- **Respect the Pax:** Format currency clearly (e.g., **150k** / pax) using `primary` for the amount and `on_surface_variant` for the "/ pax".

### Don't:
- **Don't use 100% Black:** Always use `on_surface` (#181c23) for text to maintain a premium, softer look.
- **Don't use Dividers:** If you feel the need to separate two items, add `spacing-2` of whitespace or a tonal shift.
- **Don't use Standard iOS Blue (#007AFF) Raw:** While it's our base, use our specific `primary` (#0058bc) for UI elements to ensure they feel custom and calibrated to the `surface` palette.